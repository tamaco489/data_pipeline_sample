// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.29.0
// source: users.sql

package repository

import (
	"context"
	"database/sql"
	"time"
)

const createUser = `-- name: CreateUser :exec
INSERT INTO ` + "`" + `users` + "`" + ` (
  ` + "`" + `id` + "`" + `,
  ` + "`" + `username` + "`" + `,
  ` + "`" + `email` + "`" + `,
  ` + "`" + `role` + "`" + `,
  ` + "`" + `status` + "`" + `,
  ` + "`" + `last_login_at` + "`" + `
) VALUES (
  ?,
  ?,
  ?,
  ?,
  ?,
  ?
)
`

type CreateUserParams struct {
	ID          string         `json:"id"`
	Username    sql.NullString `json:"username"`
	Email       sql.NullString `json:"email"`
	Role        UsersRole      `json:"role"`
	Status      UsersStatus    `json:"status"`
	LastLoginAt time.Time      `json:"last_login_at"`
}

func (q *Queries) CreateUser(ctx context.Context, db DBTX, arg CreateUserParams) error {
	_, err := db.ExecContext(ctx, createUser,
		arg.ID,
		arg.Username,
		arg.Email,
		arg.Role,
		arg.Status,
		arg.LastLoginAt,
	)
	return err
}

const getUserByUid = `-- name: GetUserByUid :one
SELECT
  ` + "`" + `id` + "`" + `,
  ` + "`" + `username` + "`" + `,
  ` + "`" + `email` + "`" + `,
  ` + "`" + `role` + "`" + `,
  ` + "`" + `status` + "`" + `,
  ` + "`" + `last_login_at` + "`" + `
FROM ` + "`" + `users` + "`" + `
WHERE ` + "`" + `id` + "`" + ` = ?
`

type GetUserByUidRow struct {
	ID          string         `json:"id"`
	Username    sql.NullString `json:"username"`
	Email       sql.NullString `json:"email"`
	Role        UsersRole      `json:"role"`
	Status      UsersStatus    `json:"status"`
	LastLoginAt time.Time      `json:"last_login_at"`
}

func (q *Queries) GetUserByUid(ctx context.Context, db DBTX, uid string) (GetUserByUidRow, error) {
	row := db.QueryRowContext(ctx, getUserByUid, uid)
	var i GetUserByUidRow
	err := row.Scan(
		&i.ID,
		&i.Username,
		&i.Email,
		&i.Role,
		&i.Status,
		&i.LastLoginAt,
	)
	return i, err
}
