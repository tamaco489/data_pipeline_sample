package controller

import (
	"time"

	"github.com/gin-gonic/gin"
	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/gen"
)

func (c *Controllers) CreateCustomer(ctx *gin.Context, request gen.CreateCustomerRequestObject) (gen.CreateCustomerResponseObject, error) {

	time.Sleep(150 * time.Millisecond)

	return gen.CreateCustomer201JSONResponse{
		Id: "xyz12345",
	}, nil
}
