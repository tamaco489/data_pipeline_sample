package usecase

import (
	"context"
	"database/sql"

	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/gen"
)

func (u *userUseCase) GetMe(ctx context.Context, uid string, request gen.GetMeRequestObject) (gen.GetMeResponseObject, error) {

	user, err := u.queries.GetUserByUid(ctx, u.dbtx, uid)
	if err != nil {
		if err == sql.ErrNoRows {
			return gen.GetMe404Response{}, nil
		}
		return gen.GetMe500Response{}, err
	}

	return gen.GetMe200JSONResponse{
		Uid: user.ID,
	}, nil
}
