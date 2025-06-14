-- name: ExistsChargeByReservationIDAndUserID :one
SELECT EXISTS(
  SELECT 1
  FROM charges
  WHERE reservation_id = sqlc.arg('reservation_id')
    AND user_id = sqlc.arg('user_id')
);

-- name: CreateCharge :exec
INSERT INTO charges (
  id,
  reservation_id,
  user_id,
  amount,
  status
) VALUES (
  sqlc.arg('id'),
  sqlc.arg('reservation_id'),
  sqlc.arg('user_id'),
  sqlc.arg('amount'),
  sqlc.arg('status')
);

-- name: CreateChargeProduct :exec
INSERT INTO charge_products (
  charge_id,
  product_id,
  quantity,
  unit_price
) VALUES (
  sqlc.arg('charge_id'),
  sqlc.arg('product_id'),
  sqlc.arg('quantity'),
  sqlc.arg('unit_price')
);
