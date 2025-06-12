package controller

import (
	"github.com/gin-gonic/gin"
	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/gen"
)

func (c *Controllers) GetCreditCards(ctx *gin.Context, request gen.GetCreditCardsRequestObject) (gen.GetCreditCardsResponseObject, error) {

	// NOTE: For verification purposes, passing a fixed uid to usecase
	var uid string = "01975ff1-5ba9-73ca-be9a-75aa6bb00aaf"

	creditCards, err := c.creditCardUseCase.GetCreditCards(ctx, uid, request)
	if err != nil {
		return gen.GetCreditCards500Response{}, err
	}

	return creditCards, nil
}
