package usecase

import (
	"context"
	"database/sql"
	"fmt"

	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/gen"
)

func (u *productUseCase) GetProductByID(ctx context.Context, productID uint32) (gen.GetProductByIDResponseObject, error) {

	product, err := u.queries.GetProductByID(ctx, u.db, productID)
	if err != nil {
		if err == sql.ErrNoRows {
			return gen.GetProductByID404Response{}, nil
		}
		return gen.GetProductByID500Response{}, fmt.Errorf("failed to get product by id: %w", err)
	}

	// Calculate discounted price
	discountedPrice := int64(product.Price) * int64(100-product.DiscountRate.Int32) / 100
	discountFlag := product.DiscountRate.Int32 > 0

	return gen.GetProductByID200JSONResponse{
		Id:              product.ProductID,
		Name:            product.ProductName,
		Description:     product.Description.String,
		Price:           product.Price,
		VipOnly:         product.VipOnly,
		CategoryName:    product.CategoryName,
		DiscountName:    product.DiscountName.String,
		DiscountRate:    uint32(product.DiscountRate.Int32),
		StockQuantity:   product.StockQuantity,
		DiscountedPrice: float32(discountedPrice),
		DiscountFlag:    discountFlag,
		ImageUrl:        product.MainImageUrl.String,
		Rate:            uint32(product.AverageRating),
	}, nil
}
