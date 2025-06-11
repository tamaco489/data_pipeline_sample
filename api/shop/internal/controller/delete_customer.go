package controller

import (
	"time"

	"github.com/gin-gonic/gin"
	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/gen"
)

func (c *Controllers) DeleteCustomer(ctx *gin.Context, request gen.DeleteCustomerRequestObject) (gen.DeleteCustomerResponseObject, error) {

	time.Sleep(300 * time.Millisecond)

	return gen.DeleteCustomer204Response{}, nil
}
