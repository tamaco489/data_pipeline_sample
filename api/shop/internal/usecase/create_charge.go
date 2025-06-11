package usecase

import (
	"crypto/rand"
	"fmt"
	"log/slog"
	"math/big"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/gen"
)

func (u *chargeUseCase) CreateCharge(ctx *gin.Context, request gen.CreateChargeRequestObject) (gen.CreateChargeResponseObject, error) {

	time.Sleep(1000 * time.Millisecond)

	// order_idを生成
	orderID := uuid.New().String()

	// user_idを生成（10010001 ~ 3000000までのランダムな数値を設定する）
	diff := new(big.Int).Sub(new(big.Int).SetUint64(30000000), new(big.Int).SetUint64(10010001))
	uid, err := rand.Int(rand.Reader, diff)
	if err != nil {
		return gen.CreateCharge500Response{}, fmt.Errorf("error generating rand: %v", err)
	}

	slog.InfoContext(ctx, "sample data by create charge api", "uid", uid.Uint64(), "order_id", orderID)

	return gen.CreateCharge204Response{}, nil
}
