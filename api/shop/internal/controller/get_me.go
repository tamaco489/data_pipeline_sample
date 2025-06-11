package controller

import (
	"github.com/gin-gonic/gin"
	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/gen"
)

func (c *Controllers) GetMe(ctx *gin.Context, request gen.GetMeRequestObject) (gen.GetMeResponseObject, error) {

	// NOTE: For verification purposes, passing a fixed uid to usecase
	var uid string = "01975f55-3e04-7d92-bd78-37e2568a35b8"

	res, err := c.userUseCase.GetMe(ctx, uid, request)
	if err != nil {
		return gen.GetMe500Response{}, err
	}

	return res, nil
}
