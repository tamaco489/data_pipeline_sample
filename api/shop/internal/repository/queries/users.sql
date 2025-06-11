-- name: CreateUser :exec
INSERT INTO `users` (
  `id`,
  `username`,
  `email`,
  `role`,
  `status`,
  `last_login_at`
) VALUES (
  sqlc.arg('id'),
  sqlc.arg('username'),
  sqlc.arg('email'),
  sqlc.arg('role'),
  sqlc.arg('status'),
  sqlc.arg('last_login_at')
);

-- name: GetUserByUid :one
SELECT
  `id`,
  `username`,
  `email`,
  `role`,
  `status`,
  `last_login_at`
FROM `users`
WHERE `id` = sqlc.arg('uid');
