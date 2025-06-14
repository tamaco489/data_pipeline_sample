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
