package controller

import (
	"time"

	"github.com/gin-gonic/gin"
	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/gen"
)

func (c *Controllers) GetChargeHistories(ctx *gin.Context, request gen.GetChargeHistoriesRequestObject) (gen.GetChargeHistoriesResponseObject, error) {

	metadata := gen.ChargeHistoriesLimitOffset{
		HasMore:    true,
		Limit:      10,
		Offset:     0,
		TotalCount: 100,
	}

	histories := []gen.GetChargeHistories{
		{
			ChargeId:     "9f9213b2-9687-6910-d2ec-3a247582be2d",
			ChargeAmount: 3000.0,
			ChargeDate:   time.Date(2024, time.December, 24, 12, 0, 0, 0, time.UTC),
			Products: []gen.GetChargeHistoriesProducts{
				{
					ProductId:   "12345",
					ProductName: "Sample Product",
					Quantity:    2,
					UnitPrice:   1500.0,
				},
			},
		},
		{
			ChargeId:     "9f9213b2-9687-6910-d2ec-3a247582be2e",
			ChargeAmount: 6500.0,
			ChargeDate:   time.Date(2024, time.December, 23, 14, 0, 0, 0, time.UTC),
			Products: []gen.GetChargeHistoriesProducts{
				{
					ProductId:   "67890",
					ProductName: "Another Product",
					Quantity:    3,
					UnitPrice:   1500.0,
				},
				{
					ProductId:   "99999",
					ProductName: "Extra Product 1",
					Quantity:    1,
					UnitPrice:   1000.0,
				},
				{
					ProductId:   "11111",
					ProductName: "Extra Product 2",
					Quantity:    2,
					UnitPrice:   500.0,
				},
			},
		},
		{
			ChargeId:     "9f9213b2-9687-6910-d2ec-3a247582be2f",
			ChargeAmount: 8500.0,
			ChargeDate:   time.Date(2024, time.December, 22, 10, 0, 0, 0, time.UTC),
			Products: []gen.GetChargeHistoriesProducts{
				{
					ProductId:   "11223",
					ProductName: "Deluxe Product",
					Quantity:    1,
					UnitPrice:   6000.0,
				},
				{
					ProductId:   "22334",
					ProductName: "Premium Product 1",
					Quantity:    1,
					UnitPrice:   2500.0,
				},
			},
		},
		{
			ChargeId:     "9f9213b2-9687-6910-d2ec-3a247582be30",
			ChargeAmount: 1200.0,
			ChargeDate:   time.Date(2024, time.December, 21, 8, 0, 0, 0, time.UTC),
			Products: []gen.GetChargeHistoriesProducts{
				{
					ProductId:   "44556",
					ProductName: "Economy Product",
					Quantity:    2,
					UnitPrice:   600.0,
				},
			},
		},
	}

	return gen.GetChargeHistories200JSONResponse{
		Metadata:  metadata,
		Histories: histories,
	}, nil
}
