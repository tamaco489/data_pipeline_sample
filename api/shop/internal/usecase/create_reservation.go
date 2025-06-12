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

func (u reservationUseCase) CreateReservation(ctx *gin.Context, uid string, request gen.CreateReservationRequestObject) (gen.CreateReservationResponseObject, error) {

	// Adding a 500ms delay to simulate a performance-challenged API that handles a large number of record operations.
	time.Sleep(500 * time.Millisecond)

	// ************************* Product Information Check *************************
	// Get product information. ※Product ID, Product Price, Discount Rate, Stock Quantity
	ids := make([]uint32, len(*request.Body))

	// Create a map of product_id and quantity.
	productIDQuantityMap := make(map[uint32]uint32)
	for i, p := range *request.Body {
		ids[i] = p.ProductId
		productIDQuantityMap[p.ProductId] = p.Quantity
	}

	products, err := u.queries.GetProductsByIDs(ctx, u.dbtx, ids)
	if err != nil {
		return gen.CreateReservation500Response{}, fmt.Errorf("failed to get products: %w", err)
	}

	// Validate product availability
	if err := u.validateProductAvailability(ctx, products, productIDQuantityMap); err != nil {
		return gen.CreateReservation400Response{}, nil
	}

	// ************************* Save Reservation Information *************************
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

	slog.InfoContext(ctx, "discountedPrice", "discountedPrice", discountedPrice)

	// Save reservation information. Reservation information is saved in reservation_products and reservations, so a transaction is issued.
	// Generate reservation ID
	reservationID, err := uuid.NewV7()
	if err != nil {
		return gen.CreateReservation500Response{}, fmt.Errorf("failed to new uuid for reservation: %w", err)
	}

	// Start a transaction
	tx, err := u.db.BeginTx(ctx, nil)
	if err != nil {
		return gen.CreateReservation500Response{}, fmt.Errorf("failed to begin transaction: %w", err)
	}

	// Rollback the transaction when the function exits
	defer func() { _ = tx.Rollback() }()

	// Create a reservation
	if err := u.queries.CreateReservation(ctx, tx, repository_gen_sqlc.CreateReservationParams{
		ReservationID: reservationID.String(),
		UserID:        uid,
		ReservedAt:    time.Now(),
		ExpiredAt:     time.Now().Add(15 * time.Minute), // Expires after 15 minutes
		Status:        repository_gen_sqlc.ReservationsStatusPending,
	}); err != nil {
		return gen.CreateReservation500Response{}, fmt.Errorf("failed to create reservation: %w", err)
	}

	// Create reservation products
	for _, p := range products {
		if err := u.queries.CreateReservationProduct(ctx, tx, repository_gen_sqlc.CreateReservationProductParams{
			ReservationID: reservationID.String(),
			ProductID:     p.ProductID,
			Quantity:      productIDQuantityMap[p.ProductID],
			UnitPrice:     discountedPrice[p.ProductID],
		}); err != nil {
			return gen.CreateReservation500Response{}, fmt.Errorf("failed to create reservation product: %w", err)
		}
	}

	// Commit the transaction
	if err := tx.Commit(); err != nil {
		return gen.CreateReservation500Response{}, fmt.Errorf("failed to transaction commit: %w", err)
	}

	return gen.CreateReservation201JSONResponse{
		ReservationId: reservationID.String(),
	}, nil
}

func (u reservationUseCase) validateProductAvailability(ctx *gin.Context, products []repository_gen_sqlc.GetProductsByIDsRow, productIDQuantityMap map[uint32]uint32) error {
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
