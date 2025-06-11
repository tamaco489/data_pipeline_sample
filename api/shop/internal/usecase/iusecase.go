package usecase

import (
	"context"
	"database/sql"

	"github.com/gin-gonic/gin"
	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/gen"

	repository_gen_sqlc "github.com/tamaco489/data_pipeline_sample/api/shop/internal/repository/gen_sqlc"
)

// UserUseCase
type IUserUseCase interface {
	CreateUser(ctx context.Context, sub string, request gen.CreateUserRequestObject) (gen.CreateUserResponseObject, error)
	GetMe(ctx context.Context, uid string, request gen.GetMeRequestObject) (gen.GetMeResponseObject, error)
}

type userUseCase struct {
	db      *sql.DB
	queries repository_gen_sqlc.Queries
	dbtx    repository_gen_sqlc.DBTX
}

func NewUserUseCase(
	db *sql.DB,
	queries repository_gen_sqlc.Queries,
	dbtx repository_gen_sqlc.DBTX,
) IUserUseCase {
	return &userUseCase{
		db:      db,
		queries: queries,
		dbtx:    dbtx,
	}
}

// ChargeUseCase
type IChargeUseCase interface {
	CreateCharge(ctx *gin.Context, request gen.CreateChargeRequestObject) (gen.CreateChargeResponseObject, error)
}

type chargeUseCase struct{}

func NewChargeUseCase() IChargeUseCase {
	return &chargeUseCase{}
}

// ReservationUseCase
type IReservationUseCase interface {
	CreateReservation(ctx *gin.Context, request gen.CreateReservationRequestObject) (gen.CreateReservationResponseObject, error)
}

type reservationUseCase struct{}

func NewReservationUseCase() IReservationUseCase {
	return &reservationUseCase{}
}
