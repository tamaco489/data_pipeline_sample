package controller

import (
	"fmt"

	"github.com/gin-gonic/gin"
	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/gen"
)

func (c *Controllers) GetProductByID(ctx *gin.Context, request gen.GetProductByIDRequestObject) (gen.GetProductByIDResponseObject, error) {

	productID := int32(request.ProductID)

	return gen.GetProductByID200JSONResponse{
		Id:              productID,
		Name:            "プレミアムコーヒー",
		CategoryId:      10,
		CategoryName:    "飲料",
		Description:     "香り高いアラビカ種のコーヒーです。",
		Price:           500.0,
		DiscountFlag:    true,
		DiscountName:    "2024年クリスマスキャンペーン",
		DiscountRate:    20,
		DiscountedPrice: 400.0,
		StockQuantity:   50,
		VipOnly:         false,
		ImageUrl:        fmt.Sprintf("https://example.com/images/%d/product.jpg", productID),
		Rate:            4,
	}, nil
}
