#!/bin/bash
# scripts/seeds/products/insert.sh

set -e

CONTAINER_NAME="mysql"
MYSQL_USER="root"
MYSQL_PASSWORD="password#0"
MYSQL_DATABASE="dev_core"
MYSQL_HOST="localhost"
MYSQL_PORT=33306

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
  "./scripts/seeds/loader/payments/01_credit_cards.sql"
)

for sql_file in "${SQL_FILES[@]}"
do
  echo "Executing ${sql_file} ..."
  docker compose exec -T $CONTAINER_NAME mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" < "$sql_file"
done

echo "All seed data inserted successfully."
