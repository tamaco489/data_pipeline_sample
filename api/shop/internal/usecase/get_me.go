package usecase

import (
	"context"

	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/gen"
)

func (u *userUseCase) GetMe(ctx context.Context, uid string, request gen.GetMeRequestObject) (gen.GetMeResponseObject, error) {
	return gen.GetMe200JSONResponse{
		UserId: 1, // todo: intになってるのでstringに直す。
	}, nil
}
