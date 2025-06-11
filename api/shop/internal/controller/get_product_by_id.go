package controller

import (
	"github.com/gin-gonic/gin"
	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/gen"
)

func (c *Controllers) GetProductByID(ctx *gin.Context, request gen.GetProductByIDRequestObject) (gen.GetProductByIDResponseObject, error) {

	productID := uint32(request.ProductID)

	res, err := c.productUseCase.GetProductByID(ctx, productID)
	if err != nil {
		return gen.GetProductByID500Response{}, err
	}

	return res, nil
}
