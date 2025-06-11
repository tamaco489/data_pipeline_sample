package controller

import (
	"github.com/gin-gonic/gin"
	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/gen"

	validation "github.com/go-ozzo/ozzo-validation/v4"
)

func (c *Controllers) CreateCharge(ctx *gin.Context, request gen.CreateChargeRequestObject) (gen.CreateChargeResponseObject, error) {

	err := validation.ValidateStruct(request.Body,
		validation.Field(
			&request.Body.ReservationId,
			validation.Required,
		),
	)
	if err != nil {
		_ = ctx.Error(err)
		return gen.CreateCharge400Response{}, nil
	}

	res, err := c.chargeUseCase.CreateCharge(ctx, request)
	if err != nil {
		return gen.CreateCharge500Response{}, err
	}

	return res, nil
}
