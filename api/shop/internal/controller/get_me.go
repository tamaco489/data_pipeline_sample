package controller

import (
	"github.com/gin-gonic/gin"
	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/gen"
)

func (c *Controllers) GetMe(ctx *gin.Context, request gen.GetMeRequestObject) (gen.GetMeResponseObject, error) {

	// NOTE: For verification purposes, passing a fixed uid to usecase
	var uid string = "01975ff1-5ba9-73ca-be9a-75aa6bb00aaf"

	res, err := c.userUseCase.GetMe(ctx, uid, request)
	if err != nil {
		return gen.GetMe500Response{}, err
	}

	return res, nil
}
