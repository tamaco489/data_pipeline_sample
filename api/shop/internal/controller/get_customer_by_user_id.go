package controller

import (
	"time"

	"github.com/gin-gonic/gin"
	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/gen"
)

func (c *Controllers) GetCustomerByUserID(ctx *gin.Context, request gen.GetCustomerByUserIDRequestObject) (gen.GetCustomerByUserIDResponseObject, error) {

	time.Sleep(400 * time.Millisecond)

	return gen.GetCustomerByUserID200JSONResponse{
		Id: "xyz12345",
	}, nil
}
