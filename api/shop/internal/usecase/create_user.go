package usecase

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"log/slog"
	"time"

	"github.com/go-sql-driver/mysql"
	"github.com/google/uuid"

	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/gen"

	repository_gen_sqlc "github.com/tamaco489/data_pipeline_sample/api/shop/internal/repository/gen_sqlc"
)

func (u *userUseCase) CreateUser(ctx context.Context, sub string, request gen.CreateUserRequestObject) (gen.CreateUserResponseObject, error) {

	// 認証種別に応じて既にユーザ登録済みの場合は409エラーにする

	// ユーザの新規登録を行う
	uuid, err := uuid.NewV7()
	if err != nil {
		return gen.CreateUser500Response{}, fmt.Errorf("failed to new uuid: %w", err)
	}

	// transactionを発行
	tx, err := u.db.BeginTx(ctx, nil)
	if err != nil {
		return gen.CreateUser500Response{}, fmt.Errorf("failed to begin transaction: %w", err)
	}

	// 関数を抜ける際にロールバックを行う
	defer func() { _ = tx.Rollback() }()

	// userを作成
	if err := u.queries.CreateUser(ctx, tx, repository_gen_sqlc.CreateUserParams{
		ID:          uuid.String(),
		Username:    sql.NullString{},
		Email:       sql.NullString{},
		Role:        repository_gen_sqlc.UsersRoleGeneral,
		Status:      repository_gen_sqlc.UsersStatusActive,
		LastLoginAt: time.Now(),
	}); err != nil {
		// uuidの重複エラー、ほぼ行らない想定だがハンドリングはしておく
		var mysqlErr *mysql.MySQLError
		if errors.As(err, &mysqlErr) {
			// エラーコード1062は重複エントリ（PK違反）の場合に発生
			// DOC: https://dev.mysql.com/doc/mysql-errors/8.0/en/server-error-reference.html#error_er_dup_entry
			if mysqlErr.Number == 1062 {
				slog.ErrorContext(ctx, "duplicate primary key entry.", slog.String("id", uuid.String()), slog.String("error", err.Error()))
				return gen.CreateUser409Response{}, nil
			}
		}
		return gen.CreateUser500Response{}, fmt.Errorf("failed to create user: %w", err)
	}

	return gen.CreateUser201JSONResponse{
		UserId: 1, // todo: intになってるのでstringに直す。
	}, nil
}
