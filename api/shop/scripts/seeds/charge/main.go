package main

import (
	"context"
	"database/sql"
	"fmt"
	"log/slog"
	"os"

	"github.com/google/uuid"

	_ "github.com/go-sql-driver/mysql"
)

// DBConfig: Structure for database connection information
type DBConfig struct {
	Database string
	Host     string
	Port     string
	Username string
	Password string
}

// NewDBConfig: Create a new DBConfig instance
func NewDBConfig() *DBConfig {
	return &DBConfig{
		Database: getEnvOrDefault("MYSQL_DATABASE", "dev_core"),
		Host:     getEnvOrDefault("MYSQL_HOST", "localhost"),
		Port:     getEnvOrDefault("MYSQL_PORT", "33306"),
		Username: getEnvOrDefault("MYSQL_USER", "root"),
		Password: getEnvOrDefault("MYSQL_PASSWORD", "password#0"),
	}
}

// getEnvOrDefault: Get environment variable or use default value
func getEnvOrDefault(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}

// getDSN: Get Data Source Name for database connection
func (c *DBConfig) getDSN() string {
	return fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?parseTime=true",
		c.Username,
		c.Password,
		c.Host,
		c.Port,
		c.Database,
	)
}

// ChargeRow: Structure for charge data
type ChargeRow struct {
	ReservationID         string
	UserID                string
	TotalDiscountedAmount int
	Status                string
}

// NewChargeRow: Create a new ChargeRow instance
func NewChargeRow(reservationID, userID string, totalDiscountedAmount int, status string) *ChargeRow {
	return &ChargeRow{
		ReservationID:         reservationID,
		UserID:                userID,
		TotalDiscountedAmount: totalDiscountedAmount,
		Status:                status,
	}
}

// ChargeProductRow: Structure for charge product data
type ChargeProductRow struct {
	ChargeID  string
	ProductID int
	Quantity  int
	UnitPrice int
}

// NewChargeProductRow: Create a new ChargeProductRow instance
func NewChargeProductRow(chargeID string, productID, quantity, unitPrice int) *ChargeProductRow {
	return &ChargeProductRow{
		ChargeID:  chargeID,
		ProductID: productID,
		Quantity:  quantity,
		UnitPrice: unitPrice,
	}
}

// ChargeProcessor: Structure for charge processor
type ChargeProcessor struct {
	db *sql.DB
}

// NewChargeProcessor: Create a new ChargeProcessor instance
func NewChargeProcessor() (*ChargeProcessor, error) {
	config := NewDBConfig()
	db, err := sql.Open("mysql", config.getDSN())
	if err != nil {
		return nil, fmt.Errorf("failed to open database: %w", err)
	}
	return &ChargeProcessor{db: db}, nil
}

// Close: Close the database connection
func (cp *ChargeProcessor) Close() error {
	return cp.db.Close()
}

// getConfirmedReservations: Get confirmed reservations
func (cp *ChargeProcessor) getConfirmedReservations(ctx context.Context) ([]*ChargeRow, error) {
	query := `
SELECT
	r.id AS reservation_id,
	r.user_id,
	ROUND(SUM(rp.unit_price * rp.quantity * (100 - COALESCE(dm.rate, 0)) / 100)) AS total_discounted_amount,
	r.status
FROM reservations AS r
INNER JOIN reservation_products AS rp ON r.id = rp.reservation_id
INNER JOIN products AS p ON rp.product_id = p.id
LEFT JOIN discount_master AS dm ON p.discount_id = dm.id
WHERE r.status = 'confirmed'
GROUP BY r.id;
`

	rows, err := cp.db.QueryContext(ctx, query)
	if err != nil {
		return nil, fmt.Errorf("query failed: %w", err)
	}
	defer rows.Close()

	var crows []*ChargeRow
	for rows.Next() {
		var reservationID, userID, status string
		var totalDiscountedAmount int
		if err := rows.Scan(&reservationID, &userID, &totalDiscountedAmount, &status); err != nil {
			return nil, fmt.Errorf("scan failed: %w", err)
		}
		crows = append(crows, NewChargeRow(reservationID, userID, totalDiscountedAmount, status))
	}

	return crows, nil
}

// insertCharge: Insert charge data
func (cp *ChargeProcessor) insertCharge(ctx context.Context, row *ChargeRow) (string, error) {
	query := `INSERT INTO charges (
		id, reservation_id, user_id, amount, status, charged_at, created_at, updated_at) VALUES (?, ?, ?, ?, ?, NOW(), NOW(), NOW()
	)`

	// Generate charge ID
	uuid, err := uuid.NewV7()
	if err != nil {
		return "", fmt.Errorf("failed to new uuid: %w", err)
	}

	// Set status
	var status string
	switch row.Status {
	case "confirmed":
		status = "paid"
	case "canceled":
		status = "failed"
	default:
		status = "unpaid"
	}

	// Insert charge data
	_, err = cp.db.ExecContext(ctx, query,
		uuid.String(),
		row.ReservationID,
		row.UserID,
		row.TotalDiscountedAmount,
		status,
	)
	if err != nil {
		return "", fmt.Errorf("insert failed for reservation %s: %w", row.ReservationID, err)
	}

	return uuid.String(), nil
}

// getReservationProductsForCharge: Get reservation products for charge
func (cp *ChargeProcessor) getReservationProductsForCharge(ctx context.Context, reservationID string) ([]*ChargeProductRow, error) {
	query := `
SELECT
    rp.product_id,
    rp.quantity,
    rp.unit_price
FROM reservation_products AS rp
WHERE rp.reservation_id = ?;
`
	rows, err := cp.db.QueryContext(ctx, query, reservationID)
	if err != nil {
		return nil, fmt.Errorf("query reservation_products failed for reservation %s: %w", reservationID, err)
	}
	defer rows.Close()

	var cps []*ChargeProductRow
	for rows.Next() {
		var productID, quantity, unitPrice int
		if err := rows.Scan(&productID, &quantity, &unitPrice); err != nil {
			return nil, fmt.Errorf("scan reservation_products failed for reservation %s: %w", reservationID, err)
		}
		// charge_id will be passed during insertion, so initialize with empty string here
		cps = append(cps, NewChargeProductRow("", productID, quantity, unitPrice))
	}

	return cps, nil
}

// insertChargeProduct: Insert a single charge_product data
func (cp *ChargeProcessor) insertChargeProduct(ctx context.Context, chargeID string, cpRow *ChargeProductRow) error {
	query := `INSERT INTO charge_products (
        charge_id, product_id, quantity, unit_price, created_at, updated_at) VALUES (?, ?, ?, ?, NOW(), NOW()
    )`

	_, err := cp.db.ExecContext(ctx, query,
		chargeID,
		cpRow.ProductID,
		cpRow.Quantity,
		cpRow.UnitPrice,
	)
	if err != nil {
		return fmt.Errorf("insert failed for charge_product (charge_id: %s, product_id: %d): %w", chargeID, cpRow.ProductID, err)
	}

	return nil
}

// Process: Process charge data
func (cp *ChargeProcessor) Process(ctx context.Context) error {
	slog.InfoContext(ctx, "========================= [ Start charges script ] =========================")

	// Get confirmed reservations
	rows, err := cp.getConfirmedReservations(ctx)
	if err != nil {
		return err
	}

	// Start transaction
	tx, err := cp.db.BeginTx(ctx, nil)
	if err != nil {
		return fmt.Errorf("failed to begin transaction: %w", err)
	}

	// Rollback transaction if error occurs
	defer tx.Rollback()

	for _, row := range rows {
		slog.InfoContext(ctx, "processing charge", "reservation_id", row.ReservationID)

		chargeID, err := cp.insertCharge(ctx, row)
		if err != nil {
			slog.ErrorContext(ctx, "failed to insert charge", "err", err, "reservation_id", row.ReservationID)
			continue // Next reservation
		}

		// Get charge_products data
		chargeProducts, err := cp.getReservationProductsForCharge(ctx, row.ReservationID)
		if err != nil {
			slog.ErrorContext(ctx, "failed to get reservation products for charge", "err", err, "reservation_id", row.ReservationID)
			continue // Next reservation
		}

		// Insert charge_products data
		for _, cpRow := range chargeProducts {
			if err := cp.insertChargeProduct(ctx, chargeID, cpRow); err != nil {
				slog.ErrorContext(ctx, "insert charge_product failed", "err", err, "reservation_id", row.ReservationID, "product_id", cpRow.ProductID)
				continue // Next charge_product
			}
			slog.InfoContext(ctx, "inserted charge_product", "charge_id", chargeID, "product_id", cpRow.ProductID)
		}
	}

	// Commit transaction
	if err := tx.Commit(); err != nil {
		return fmt.Errorf("failed to commit transaction: %w", err)
	}

	return nil
}

// main: Main function
func main() {
	ctx := context.Background()

	processor, err := NewChargeProcessor()
	if err != nil {
		panic(err)
	}
	defer processor.Close()

	if err := processor.Process(ctx); err != nil {
		panic(err)
	}

	slog.InfoContext(ctx, "charge script completed")
}
