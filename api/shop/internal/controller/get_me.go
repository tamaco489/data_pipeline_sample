package controller

import (
	"github.com/gin-gonic/gin"
	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/gen"
)

func (c *Controllers) GetMe(ctx *gin.Context, request gen.GetMeRequestObject) (gen.GetMeResponseObject, error) {

	// NOTE: uidは一旦固定値で返す
	var uid string = "10001001"

	res, err := c.userUseCase.GetMe(ctx, uid, request)
	if err != nil {
		return gen.GetMe500Response{}, err
	}

	return res, nil
}
