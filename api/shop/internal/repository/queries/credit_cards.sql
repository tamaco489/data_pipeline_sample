-- name: GetCreditCardsByUserId :many
SELECT
  user_id,
  payment_provider_card_id,
  provider_type,
  is_default
FROM credit_cards
WHERE user_id = sqlc.arg('uid');
