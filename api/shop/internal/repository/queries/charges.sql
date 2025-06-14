-- name: CreateCharge :exec
INSERT INTO charges (
  id,
  reservation_id,
  user_id,
  amount,
  status,
  charged_at
) VALUES (
  sqlc.arg('id'),
  sqlc.arg('reservation_id'),
  sqlc.arg('user_id'),
  sqlc.arg('amount'),
  sqlc.arg('status'),
  sqlc.arg('charged_at')
);
