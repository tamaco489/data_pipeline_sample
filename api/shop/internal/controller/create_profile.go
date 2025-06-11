package controller

import (
	"time"

	"github.com/gin-gonic/gin"
	"github.com/oapi-codegen/runtime/types"
	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/gen"
)

func (c *Controllers) CreateProfile(ctx *gin.Context, request gen.CreateProfileRequestObject) (gen.CreateProfileResponseObject, error) {

	return gen.CreateProfile201JSONResponse{
		Address: gen.Addresses{
			Region:     "関東",
			ZipCode:    "150-8377",
			Prefecture: "東京都",
			City:       "渋谷区",
			Street:     "宇田川町",
			Other:      "15番1号",
		},
		Birthdate: types.Date{Time: time.Date(2000, 1, 1, 0, 0, 0, 0, time.UTC)},
		ImageUrl:  "https://s3.amazonaws.com/shop-images/profile/10001001/sr56gsad4hs5244gfs2456.jpg",
		Name: gen.Name{
			FirstName:      "智",
			FirstNameRoman: "Satoshi",
			LastName:       "真皿",
			LastNameRoman:  "Masara",
		},
	}, nil
}
