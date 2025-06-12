package usecase

import (
	"fmt"
	"log/slog"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/gen"

	repository_gen_sqlc "github.com/tamaco489/data_pipeline_sample/api/shop/internal/repository/gen_sqlc"
)

func (ru reservationUseCase) CreateReservation(ctx *gin.Context, uid string, request gen.CreateReservationRequestObject) (gen.CreateReservationResponseObject, error) {

	// Adding a 500ms delay to simulate a performance-challenged API that handles a large number of record operations.
	time.Sleep(500 * time.Millisecond)

	// Get product information. ※Product ID, Product Price, Discount Rate, Stock Quantity
	ids := make([]uint32, len(*request.Body))

	// Create a map of product_id and quantity.
	productIDQuantityMap := make(map[uint32]uint32)
	for i, p := range *request.Body {
		ids[i] = p.ProductId
		productIDQuantityMap[p.ProductId] = p.Quantity
	}

	products, err := ru.queries.GetProductsByIDs(ctx, ru.dbtx, ids)
	if err != nil {
		return gen.CreateReservation500Response{}, fmt.Errorf("failed to get products: %w", err)
	}

	// Validate product availability
	if err := ru.validateProductAvailability(ctx, products, productIDQuantityMap); err != nil {
		return gen.CreateReservation400Response{}, nil
	}

	// Calculate the discounted price of the product.
	discountedPriceMap := ru.calculateDiscountedPrices(products)

	// Save reservation information. Reservation information is saved in reservation_products and reservations, so a transaction is issued.
	reservationID, err := ru.saveReservation(ctx, uid, products, productIDQuantityMap, discountedPriceMap)
	if err != nil {
		return gen.CreateReservation500Response{}, nil
	}

	return gen.CreateReservation201JSONResponse{
		ReservationId: reservationID,
	}, nil
}

// validateProductAvailability: Validate product stock quantities. Check product existence, stock quantity, and order quantity.
func (ru reservationUseCase) validateProductAvailability(ctx *gin.Context, products []repository_gen_sqlc.GetProductsByIDsRow, productIDQuantityMap map[uint32]uint32) error {
	// If no product is found, return 404.
	if len(products) == 0 {
		slog.ErrorContext(ctx, "product not found")
		return fmt.Errorf("product not found")
	}

	for _, p := range products {
		// If the stock quantity is 0
		if p.ProductStockQuantity == 0 {
			slog.ErrorContext(
				ctx,
				"product out of stock",
				"product_id", p.ProductID,
				"product_stock_quantity", p.ProductStockQuantity,
			)
			return fmt.Errorf("product out of stock")
		}
		// If the requested quantity exceeds the stock quantity
		if p.ProductStockQuantity < productIDQuantityMap[p.ProductID] {
			slog.ErrorContext(
				ctx,
				"product stock quantity is less than requested quantity",
				"product_id", p.ProductID,
				"product_stock_quantity", p.ProductStockQuantity,
				"requested_quantity", productIDQuantityMap[p.ProductID],
			)
			return fmt.Errorf("product stock quantity is less than requested quantity")
		}
	}

	return nil
}

// calculateDiscountedPrices: Calculate discounted prices for products based on the discount rate. If no discount rate is set, use the regular product price.
func (ru reservationUseCase) calculateDiscountedPrices(products []repository_gen_sqlc.GetProductsByIDsRow) map[uint32]uint32 {
	// If the discount rate is specified for the product, change the price to the discounted price. If the discount rate is not specified, use the product price as is.
	discountedPrice := make(map[uint32]uint32)
	for _, p := range products {
		// If the discount rate is specified, change the price to the discounted price.
		if p.DiscountRate.Valid {
			discountedPrice[p.ProductID] = uint32(p.ProductPrice * (100 - p.DiscountRate.Int32) / 100)
		}
		// If the discount rate is not specified, use the product price as is.
		if !p.DiscountRate.Valid {
			discountedPrice[p.ProductID] = uint32(p.ProductPrice)
		}
	}

	return discountedPrice
}

// saveReservation: Save reservation information. Reservation information is saved in reservation_products and reservations, so a transaction is issued.
func (ru reservationUseCase) saveReservation(ctx *gin.Context, uid string, products []repository_gen_sqlc.GetProductsByIDsRow, productIDQuantityMap map[uint32]uint32, discountedPriceMap map[uint32]uint32) (string, error) {

	// Generate reservation ID
	reservationID, err := uuid.NewV7()
	if err != nil {
		return "", fmt.Errorf("failed to new uuid for reservation: %w", err)
	}

	// Start a transaction
	tx, err := ru.db.BeginTx(ctx, nil)
	if err != nil {
		return "", fmt.Errorf("failed to begin transaction: %w", err)
	}

	// Rollback the transaction when the function exits
	defer func() { _ = tx.Rollback() }()

	// Create a reservation
	if err := ru.queries.CreateReservation(ctx, tx, repository_gen_sqlc.CreateReservationParams{
		ReservationID: reservationID.String(),
		UserID:        uid,
		ReservedAt:    time.Now(),
		ExpiredAt:     time.Now().Add(15 * time.Minute), // Expires after 15 minutes
		Status:        repository_gen_sqlc.ReservationsStatusPending,
	}); err != nil {
		return "", fmt.Errorf("failed to create reservation: %w", err)
	}

	// Create reservation products
	for _, p := range products {
		if err := ru.queries.CreateReservationProduct(ctx, tx, repository_gen_sqlc.CreateReservationProductParams{
			ReservationID: reservationID.String(),
			ProductID:     p.ProductID,
			Quantity:      productIDQuantityMap[p.ProductID],
			UnitPrice:     discountedPriceMap[p.ProductID],
		}); err != nil {
			return "", fmt.Errorf("failed to create reservation product: %w", err)
		}
	}

	// Commit the transaction
	if err := tx.Commit(); err != nil {
		return "", fmt.Errorf("failed to transaction commit: %w", err)
	}

	return reservationID.String(), nil
}
