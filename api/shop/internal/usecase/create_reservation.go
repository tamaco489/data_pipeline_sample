package usecase

import (
	"fmt"
	"log/slog"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/gen"
)

func (u reservationUseCase) CreateReservation(ctx *gin.Context, uid string, request gen.CreateReservationRequestObject) (gen.CreateReservationResponseObject, error) {

	time.Sleep(500 * time.Millisecond)

	// ************************* 商品情報のチェック *************************
	// todo: 商品情報を取得する。※商品ID, 商品価格, 割引率, 在庫数
	ids := make([]uint32, len(*request.Body))
	for i, p := range *request.Body {
		ids[i] = p.ProductId
	}

	products, err := u.queries.GetProductsByIDs(ctx, u.dbtx, ids)
	if err != nil {
		return gen.InternalServerErrorResponse{}, fmt.Errorf("failed to get products: %w", err)
	}

	slog.InfoContext(ctx, "検証中です", "products", products)

	// todo: 商品は複数指定可能だが1件でも在庫0件のものがある場合は404を返す。

	// todo: 指定した商品数が在庫数を超えている場合は400を返す。

	// ************************* 予約情報を保存 *************************
	// todo: 商品に割引率が指定されている場合は、割引率を適用した価格に変更する。割引率が指定されていない場合は、商品価格をそのまま使用する。

	// todo: 予約情報を保存する。予約情報は reservation_products, reservations に保存するため transaction を発行する。
	// Generate reservation ID
	reservationID, err := uuid.NewV7()
	if err != nil {
		return gen.InternalServerErrorResponse{}, fmt.Errorf("failed to new uuid for reservation: %w", err)
	}

	return gen.CreateReservation201JSONResponse{
		ReservationId: reservationID.String(),
	}, nil
}
