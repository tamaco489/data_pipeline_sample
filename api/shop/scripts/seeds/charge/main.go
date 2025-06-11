package main

import (
	"context"
	"database/sql"
	"fmt"
	"log/slog"

	"github.com/google/uuid"

	_ "github.com/go-sql-driver/mysql"
)

type ChargeRow struct {
	ReservationID         string
	UserID                string
	TotalDiscountedAmount int
	Status                string
}

func dbOpen() (*sql.DB, error) {
	db, err := sql.Open("mysql", "core:password@tcp(localhost:33306)/dev_core?parseTime=true")
	if err != nil {
		return nil, fmt.Errorf("failed to open database: %w", err)
	}
	return db, nil
}

func getConfirmedReservations(ctx context.Context, db *sql.DB) ([]*ChargeRow, error) {
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

	rows, err := db.QueryContext(ctx, query)
	if err != nil {
		return nil, fmt.Errorf("query failed: %w", err)
	}
	defer rows.Close()

	var crows []*ChargeRow
	for rows.Next() {
		var row ChargeRow
		if err := rows.Scan(&row.ReservationID, &row.UserID, &row.TotalDiscountedAmount, &row.Status); err != nil {
			return nil, fmt.Errorf("scan failed: %w", err)
		}
		crows = append(crows, &row)
	}

	return crows, nil
}

func insertCharge(ctx context.Context, db *sql.DB, row *ChargeRow) error {
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

	_, err = db.ExecContext(ctx, query,
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

func handler(ctx context.Context) error {
	slog.InfoContext(ctx, "start charges script")

	db, err := dbOpen()
	if err != nil {
		return err
	}
	defer db.Close()

	rows, err := getConfirmedReservations(ctx, db)
	if err != nil {
		return err
	}

	for _, row := range rows {
		if err := insertCharge(ctx, db, row); err != nil {
			slog.ErrorContext(ctx, "insert failed", "err", err, "reservation_id", row.ReservationID)
			// continue if you want to proceed with processing, return if you want to abort on failure
			continue
		}
		slog.InfoContext(ctx, "inserted charge", "reservation_id", row.ReservationID)
	}

	return nil
}

func main() {
	ctx := context.Background()
	if err := handler(ctx); err != nil {
		panic(err)
	}

	slog.InfoContext(ctx, "charge script completed")
}
