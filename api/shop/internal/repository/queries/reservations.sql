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

-- name: GetPendingReservationByIDAndUserID :many
SELECT
  rp.product_id,
  rp.quantity,
  rp.unit_price,
  rs.expired_at
FROM reservations AS rs
INNER JOIN reservation_products AS rp ON rs.id = rp.reservation_id
WHERE
  rs.id = sqlc.arg('reservation_id')
  AND rs.user_id = sqlc.arg('user_id')
  AND rs.status = sqlc.arg('status')
  AND rs.expired_at > CURRENT_TIMESTAMP
ORDER BY rp.product_id;

-- name: UpdateReservationStatus :exec
UPDATE reservations SET status = sqlc.arg('status') WHERE id = sqlc.arg('reservation_id');
