package controller

import (
	"time"

	"github.com/gin-gonic/gin"
	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/gen"
)

func (c *Controllers) GetCreditCards(ctx *gin.Context, request gen.GetCreditCardsRequestObject) (gen.GetCreditCardsResponseObject, error) {

	time.Sleep(2000 * time.Millisecond)

	creditCards := []gen.CreditCardList{
		{
			IsDefault:        true,
			MaskedCardNumber: "******123",
		},
		{
			IsDefault:        false,
			MaskedCardNumber: "******567",
		},
		{
			IsDefault:        false,
			MaskedCardNumber: "******890",
		},
	}

	return gen.GetCreditCards200JSONResponse(creditCards), nil
}
