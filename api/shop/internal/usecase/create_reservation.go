package usecase

import (
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/gen"
)

func (u reservationUseCase) CreateReservation(ctx *gin.Context, request gen.CreateReservationRequestObject) (gen.CreateReservationResponseObject, error) {

	time.Sleep(300 * time.Millisecond)

	reservationID := uuid.New().String()

	return gen.CreateReservation201JSONResponse{
		ReservationId: reservationID,
	}, nil
}
