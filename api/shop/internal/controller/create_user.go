package controller

import (
	"github.com/gin-gonic/gin"
	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/gen"
)

func (c *Controllers) CreateUser(ctx *gin.Context, request gen.CreateUserRequestObject) (gen.CreateUserResponseObject, error) {

	// NOTE: sub is a fixed value for verification purposes
	var sub string = "2iSI3im4bcOFJDoT7E9QLebbU9G2"

	res, err := c.userUseCase.CreateUser(ctx, sub, request)
	if err != nil {
		return gen.CreateUser500Response{}, err
	}

	return res, nil
}
