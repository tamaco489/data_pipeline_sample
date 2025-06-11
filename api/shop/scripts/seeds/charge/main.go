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

type DBConfig struct {
	Database string
	Host     string
	Port     string
	Username string
	Password string
}

func NewDBConfig() *DBConfig {
	return &DBConfig{
		Database: getEnvOrDefault("MYSQL_DATABASE", "dev_core"),
		Host:     getEnvOrDefault("MYSQL_HOST", "localhost"),
		Port:     getEnvOrDefault("MYSQL_PORT", "33306"),
		Username: getEnvOrDefault("MYSQL_USERNAME", "core"),
		Password: getEnvOrDefault("MYSQL_PASSWORD", "password"),
	}
}

func getEnvOrDefault(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}

func (c *DBConfig) getDSN() string {
	return fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?parseTime=true",
		c.Username,
		c.Password,
		c.Host,
		c.Port,
		c.Database,
	)
}

type ChargeRow struct {
	ReservationID         string
	UserID                string
	TotalDiscountedAmount int
	Status                string
}

func NewChargeRow(reservationID, userID string, totalDiscountedAmount int, status string) *ChargeRow {
	return &ChargeRow{
		ReservationID:         reservationID,
		UserID:                userID,
		TotalDiscountedAmount: totalDiscountedAmount,
		Status:                status,
	}
}

type ChargeProcessor struct {
	db *sql.DB
}

func NewChargeProcessor() (*ChargeProcessor, error) {
	config := NewDBConfig()
	db, err := sql.Open("mysql", config.getDSN())
	if err != nil {
		return nil, fmt.Errorf("failed to open database: %w", err)
	}
	return &ChargeProcessor{db: db}, nil
}

func (cp *ChargeProcessor) Close() error {
	return cp.db.Close()
}

func (cp *ChargeProcessor) getConfirmedReservations(ctx context.Context) ([]*ChargeRow, error) {
	query := `
SELECT
	r.id AS reservation_id,
	r.user_id,
	ROUND(SUM(rp.unit_price * rp.quantity * (100 - dm.rate) / 100)) AS total_discounted_amount,
	r.status
FROM reservations AS r
INNER JOIN reservation_products AS rp ON r.id = rp.reservation_id
INNER JOIN products AS p ON rp.product_id = p.id
INNER JOIN discount_master AS dm ON p.discount_id = dm.id
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

func (cp *ChargeProcessor) insertCharge(ctx context.Context, row *ChargeRow) error {
	query := `INSERT INTO charges (
		id, reservation_id, user_id, amount, status, charged_at, created_at, updated_at) VALUES (?, ?, ?, ?, ?, NOW(), NOW(), NOW()
	)`

	uuid, err := uuid.NewV7()
	if err != nil {
		return fmt.Errorf("failed to new uuid: %w", err)
	}

	var status string
	switch row.Status {
	case "confirmed":
		status = "paid"
	case "canceled":
		status = "failed"
	default:
		status = "unpaid"
	}

	_, err = cp.db.ExecContext(ctx, query,
		uuid.String(),
		row.ReservationID,
		row.UserID,
		row.TotalDiscountedAmount,
		status,
	)
	if err != nil {
		return fmt.Errorf("insert failed for reservation %s: %w", row.ReservationID, err)
	}

	return nil
}

func (cp *ChargeProcessor) Process(ctx context.Context) error {
	slog.InfoContext(ctx, "start charges script")

	rows, err := cp.getConfirmedReservations(ctx)
	if err != nil {
		return err
	}

	for _, row := range rows {
		if err := cp.insertCharge(ctx, row); err != nil {
			slog.ErrorContext(ctx, "insert failed", "err", err, "reservation_id", row.ReservationID)
			continue
		}
		slog.InfoContext(ctx, "inserted charge", "reservation_id", row.ReservationID)
	}

	return nil
}

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
