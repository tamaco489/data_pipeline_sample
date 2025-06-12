-- name: CreateReservation :exec
INSERT INTO reservations (
  id,
  user_id,
  reserved_at,
  expired_at,
  status
) VALUES (
  sqlc.arg('reservation_id'),
  sqlc.arg('user_id'),
  sqlc.arg('reserved_at'),
  sqlc.arg('expired_at'),
  sqlc.arg('status')
);

-- name: CreateReservationProduct :exec
INSERT INTO reservation_products (
  reservation_id,
  product_id,
  quantity,
  unit_price
)
VALUES (
  sqlc.arg('reservation_id'),
  sqlc.arg('product_id'),
  sqlc.arg('quantity'),
  sqlc.arg('unit_price')
);
