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
	productUseCase     usecase.IProductUseCase
	creditCardUseCase  usecase.ICreditCardUseCase
	reservationUseCase usecase.IReservationUseCase
	chargeUseCase      usecase.IChargeUseCase
}

func NewControllers(cfg configuration.Config, db *sql.DB, queries repository_gen_sqlc.Queries) (*Controllers, error) {
	userUseCase := usecase.NewUserUseCase(db, queries, db)
	productUseCase := usecase.NewProductUseCase(db, queries, db)
	creditCardUseCase := usecase.NewCreditCardUseCase(db, queries, db)
	reservationUseCase := usecase.NewReservationUseCase()
	chargeUseCase := usecase.NewChargeUseCase()
	return &Controllers{
		cfg,
		userUseCase,
		productUseCase,
		creditCardUseCase,
		reservationUseCase,
		chargeUseCase,
	}, nil
}
