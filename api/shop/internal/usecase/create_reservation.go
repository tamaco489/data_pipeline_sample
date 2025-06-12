package usecase

import (
	"log/slog"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/gen"
)

func (u reservationUseCase) CreateReservation(ctx *gin.Context, uid string, request gen.CreateReservationRequestObject) (gen.CreateReservationResponseObject, error) {

	time.Sleep(500 * time.Millisecond)

	reservationID := uuid.New().String()

	slog.InfoContext(ctx, "sample data by create reservation api",
		"uid", uid,
		"request", request.Body,
		"reservation_id", reservationID)

	return gen.CreateReservation201JSONResponse{
		ReservationId: reservationID,
	}, nil
}
