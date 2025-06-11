package controller

import (
	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/configuration"
	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/usecase"
)

type Controllers struct {
	config             configuration.Config
	chargeUseCase      usecase.IChargeUseCase
	reservationUseCase usecase.IReservationUseCase
}

func NewControllers(cnf configuration.Config) (*Controllers, error) {
	// usecase
	chargeUseCase := usecase.NewChargeUseCase()
	reservationUseCase := usecase.NewReservationUseCase()

	return &Controllers{
		cnf,
		chargeUseCase,
		reservationUseCase,
	}, nil
}
