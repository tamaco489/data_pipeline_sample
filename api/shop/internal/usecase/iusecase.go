package usecase

import (
	"github.com/gin-gonic/gin"
	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/gen"
)

type IChargeUseCase interface {
	CreateCharge(ctx *gin.Context, request gen.CreateChargeRequestObject) (gen.CreateChargeResponseObject, error)
}

type IReservationUseCase interface {
	CreateReservation(ctx *gin.Context, request gen.CreateReservationRequestObject) (gen.CreateReservationResponseObject, error)
}

type chargeUseCase struct{}

type reservationUseCase struct{}

func NewChargeUseCase() IChargeUseCase {
	return &chargeUseCase{}
}

func NewReservationUseCase() IReservationUseCase {
	return &reservationUseCase{}
}
