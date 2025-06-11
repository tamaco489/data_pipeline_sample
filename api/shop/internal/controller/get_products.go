package controller

import (
	"math/rand"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/gen"
)

func (c *Controllers) GetProducts(ctx *gin.Context, request gen.GetProductsRequestObject) (gen.GetProductsResponseObject, error) {

	metadata := gen.ProductNextCursor{NextCursor: "MjAwMDI5OTA="}
	products := []gen.GetProducts{
		{
			Id:              20001001,
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
			ImageUrl:        "https://example.com/images/20001001/product.jpg",
			Rate:            4,
		},
		{
			Id:              20001002,
			Name:            "エスプレッソマシン",
			CategoryId:      20,
			CategoryName:    "キッチン用品",
			Description:     "自宅で本格的なエスプレッソを楽しめるマシン。",
			Price:           20000.0,
			DiscountFlag:    false,
			DiscountName:    "",
			DiscountRate:    0,
			DiscountedPrice: 20000.0,
			StockQuantity:   10,
			VipOnly:         true,
			ImageUrl:        "https://example.com/images/20001002/product.jpg",
			Rate:            5,
		},
		{
			Id:              20001003,
			Name:            "ハンドメイドマグカップ",
			CategoryId:      30,
			CategoryName:    "食器",
			Description:     "温もりのあるデザインのハンドメイドマグカップ。",
			Price:           1500.0,
			DiscountFlag:    true,
			DiscountName:    "新生活応援セール",
			DiscountRate:    10,
			DiscountedPrice: 1350.0,
			StockQuantity:   100,
			VipOnly:         false,
			ImageUrl:        "https://example.com/images/20001002/product.jpg",
			Rate:            2,
		},
	}

	// ローカルな乱数ジェネレーターを作成
	r := rand.New(rand.NewSource(time.Now().UnixNano()))

	// 0, 1, 2 のどれかをランダムに選択
	pattern := r.Intn(3)

	switch pattern {
	case 1:
		metadata = gen.ProductNextCursor{NextCursor: ""}
		products = products[:1]
	case 2:
		metadata = gen.ProductNextCursor{NextCursor: ""}
		products = []gen.GetProducts{}
	default:
		// 何もせずそのまま返す
	}

	return gen.GetProducts200JSONResponse{
		Metadata: metadata,
		Products: products,
	}, nil
}
