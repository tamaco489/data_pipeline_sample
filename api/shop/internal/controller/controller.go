package controller

import (
	"database/sql"

	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/configuration"
	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/usecase"

	repository_gen_sqlc "github.com/tamaco489/data_pipeline_sample/api/shop/internal/repository/gen_sqlc"
)

type Controllers struct {
	config             configuration.Config
	userUseCase        usecase.IUserUseCase
	chargeUseCase      usecase.IChargeUseCase
	reservationUseCase usecase.IReservationUseCase
}

func NewControllers(cfg configuration.Config, db *sql.DB, queries repository_gen_sqlc.Queries) (*Controllers, error) {
	userUseCase := usecase.NewUserUseCase(db, queries, db)
	chargeUseCase := usecase.NewChargeUseCase()
	reservationUseCase := usecase.NewReservationUseCase()
	return &Controllers{
		cfg,
		userUseCase,
		chargeUseCase,
		reservationUseCase,
	}, nil
}
