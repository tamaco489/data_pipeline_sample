// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.29.0
// source: charges.sql

package repository

import (
	"context"
)

const createCharge = `-- name: CreateCharge :exec
INSERT INTO charges (
  id,
  reservation_id,
  user_id,
  amount,
  status
) VALUES (
  ?,
  ?,
  ?,
  ?,
  ?
)
`

type CreateChargeParams struct {
	ID            string        `json:"id"`
	ReservationID string        `json:"reservation_id"`
	UserID        string        `json:"user_id"`
	Amount        uint32        `json:"amount"`
	Status        ChargesStatus `json:"status"`
}

func (q *Queries) CreateCharge(ctx context.Context, db DBTX, arg CreateChargeParams) error {
	_, err := db.ExecContext(ctx, createCharge,
		arg.ID,
		arg.ReservationID,
		arg.UserID,
		arg.Amount,
		arg.Status,
	)
	return err
}

const createChargeProduct = `-- name: CreateChargeProduct :exec
INSERT INTO charge_products (
  charge_id,
  product_id,
  quantity,
  unit_price
) VALUES (
  ?,
  ?,
  ?,
  ?
)
`

type CreateChargeProductParams struct {
	ChargeID  string `json:"charge_id"`
	ProductID uint32 `json:"product_id"`
	Quantity  uint32 `json:"quantity"`
	UnitPrice uint32 `json:"unit_price"`
}

func (q *Queries) CreateChargeProduct(ctx context.Context, db DBTX, arg CreateChargeProductParams) error {
	_, err := db.ExecContext(ctx, createChargeProduct,
		arg.ChargeID,
		arg.ProductID,
		arg.Quantity,
		arg.UnitPrice,
	)
	return err
}

const existsChargeByReservationIDAndUserID = `-- name: ExistsChargeByReservationIDAndUserID :one
SELECT EXISTS(
  SELECT 1
  FROM charges
  WHERE reservation_id = ?
    AND user_id = ?
)
`

type ExistsChargeByReservationIDAndUserIDParams struct {
	ReservationID string `json:"reservation_id"`
	UserID        string `json:"user_id"`
}

func (q *Queries) ExistsChargeByReservationIDAndUserID(ctx context.Context, db DBTX, arg ExistsChargeByReservationIDAndUserIDParams) (bool, error) {
	row := db.QueryRowContext(ctx, existsChargeByReservationIDAndUserID, arg.ReservationID, arg.UserID)
	var exists bool
	err := row.Scan(&exists)
	return exists, err
}
