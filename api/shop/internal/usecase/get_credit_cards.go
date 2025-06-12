package usecase

import (
	"context"

	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/gen"
)

func (u *creditCardUseCase) GetCreditCards(ctx context.Context, uid string, request gen.GetCreditCardsRequestObject) (gen.GetCreditCardsResponseObject, error) {

	creditCards, err := u.queries.GetCreditCardsByUserId(ctx, u.dbtx, uid)
	if err != nil {
		return gen.GetCreditCards500Response{}, err
	}

	creditCardList := make([]gen.CreditCardList, len(creditCards))
	for i, creditCard := range creditCards {
		creditCardList[i] = gen.CreditCardList{
			PaymentProviderCardId: creditCard.PaymentProviderCardID,
			ProviderType:          string(creditCard.ProviderType),
			IsDefault:             creditCard.IsDefault,
		}
	}

	return gen.GetCreditCards200JSONResponse(creditCardList), nil
}
