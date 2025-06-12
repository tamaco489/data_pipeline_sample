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

	time.Sleep(500 * time.Millisecond)

	// ************************* 商品情報のチェック *************************
	// todo: 商品情報を取得する。※商品ID, 商品価格, 割引率, 在庫数
	ids := make([]uint32, len(*request.Body))

	// product_id と quantity の map を作成する。
	productIDQuantityMap := make(map[uint32]uint32)
	for i, p := range *request.Body {
		ids[i] = p.ProductId
		productIDQuantityMap[p.ProductId] = p.Quantity
	}

	products, err := u.queries.GetProductsByIDs(ctx, u.dbtx, ids)
	if err != nil {
		return gen.CreateReservation500Response{}, fmt.Errorf("failed to get products: %w", err)
	}

	// 指定した商品が1つも存在しなかった場合は404を返す。
	if len(products) == 0 {
		slog.ErrorContext(ctx, "Product not found", "product_ids", ids)
		return gen.CreateReservation404Response{}, nil
	}

	for _, p := range products {
		// todo: 在庫0件のものがある場合は404を返す。
		if p.ProductStockQuantity == 0 {
			slog.ErrorContext(
				ctx,
				"Product out of stock",
				"product_id", p.ProductID,
				"product_stock_quantity", p.ProductStockQuantity,
			)
			return gen.CreateReservation404Response{}, nil
		}
		// todo: リクエストで指定した商品数が在庫数を超えている場合は400を返す。
		if p.ProductStockQuantity < productIDQuantityMap[p.ProductID] {
			slog.ErrorContext(
				ctx,
				"Product stock quantity is less than requested quantity",
				"product_id", p.ProductID,
				"product_stock_quantity", p.ProductStockQuantity,
				"requested_quantity", productIDQuantityMap[p.ProductID],
			)
			return gen.CreateReservation400Response{}, nil
		}
	}

	// ************************* 予約情報を保存 *************************
	// todo: 商品に割引率が指定されている場合は、割引率を適用した価格に変更する。割引率が指定されていない場合は、商品価格をそのまま使用する。
	discountedPrice := make(map[uint32]uint32)
	for _, p := range products {
		// 割引率が指定されている場合は、割引率を適用した価格に変更する。
		if p.DiscountRate.Valid {
			discountedPrice[p.ProductID] = uint32(p.ProductPrice * (100 - p.DiscountRate.Int32) / 100)
		}
		// 割引率が指定されていない場合は、商品価格をそのまま使用する。
		if !p.DiscountRate.Valid {
			discountedPrice[p.ProductID] = uint32(p.ProductPrice)
		}
	}

	slog.InfoContext(ctx, "discountedPrice", "discountedPrice", discountedPrice)

	// todo: 予約情報を保存する。予約情報は reservation_products, reservations に保存するため transaction を発行する。
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
