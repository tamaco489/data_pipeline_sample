#!/bin/bash
# scripts/seeds/products/insert.sh

set -e

# === Default Values ===
CONTAINER_NAME="mysql"
MYSQL_USER="${MYSQL_USER:-root}"
MYSQL_PASSWORD="${MYSQL_PASSWORD:-password#0}"
MYSQL_DATABASE="${MYSQL_DATABASE:-dev_core}"
MYSQL_HOST="${MYSQL_HOST:-localhost}"
MYSQL_PORT="${MYSQL_PORT:-33306}"

# === Log ===
echo "CONTAINER_NAME=${CONTAINER_NAME}"
echo "MYSQL_USER=${MYSQL_USER}"
echo "MYSQL_PASSWORD=${MYSQL_PASSWORD}"
echo "MYSQL_DATABASE=${MYSQL_DATABASE}"
echo "MYSQL_HOST=${MYSQL_HOST}"
echo "MYSQL_PORT=${MYSQL_PORT}"

# === Target SQL ===
SQL_FILES=(
  # users
  "./scripts/seeds/loader/users/01_users.sql"

  # products
  "./scripts/seeds/loader/products/01_category_master.sql"
  "./scripts/seeds/loader/products/02_discount_master.sql"
  "./scripts/seeds/loader/products/03_products.sql"
  "./scripts/seeds/loader/products/04_product_stocks.sql"
  "./scripts/seeds/loader/products/05_product_images.sql"
  "./scripts/seeds/loader/products/06_product_ratings.sql"

  # payments
  "./scripts/seeds/loader/payments/01_payment_provider_customers.sql"
  "./scripts/seeds/loader/payments/02_credit_cards.sql"
  "./scripts/seeds/loader/payments/03_reservations.sql"
  "./scripts/seeds/loader/payments/04_reservation_products.sql"
)

# === Execute ===
for sql_file in "${SQL_FILES[@]}"
do
  echo "Executing ${sql_file} ..."
  docker compose exec -T $CONTAINER_NAME \
    mysql -h"$MYSQL_HOST" -P"$MYSQL_PORT" \
    -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" \
    "$MYSQL_DATABASE" < "$sql_file"
done

echo "All seed data inserted successfully."
