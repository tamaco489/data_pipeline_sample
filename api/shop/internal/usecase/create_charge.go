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

	// *************** [TODO] ***************
	// todo: transaction を使って、以下の処理を行う
	// 1. reservations テーブルの status を confirmed に更新
	// 2. charges テーブルにデータを登録
	// 3. charge_products テーブルにデータを登録
	// 4. エラーが発生した場合は rollback、全ての処理が成功した場合は commit

	// *************** [リクエストの検証] ***************
	// todo: reservation_id の存在確認、予約ステータスが confirmed かの確認、合致しない場合は403を返す。※where句には reservation_id と user_id を指定

	// todo: 有効な reservation_id に紐づく商品情報を取得し、その商品情報をもとに charges, charge_products テーブルにデータを登録する。

	return gen.CreateCharge204Response{}, nil
}
