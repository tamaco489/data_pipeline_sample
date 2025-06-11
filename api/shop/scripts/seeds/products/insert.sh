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
  "./scripts/seeds/products/01_category_master.sql"
  "./scripts/seeds/products/02_discount_master.sql"
  "./scripts/seeds/products/03_products.sql"
  "./scripts/seeds/products/04_product_stocks.sql"
  "./scripts/seeds/products/05_product_images.sql"
  # "./scripts/seeds/products/06_product_ratings.sql"
)

for sql_file in "${SQL_FILES[@]}"
do
  echo "Executing ${sql_file} ..."
  docker compose exec -T $CONTAINER_NAME mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" < "$sql_file"
done

echo "All seed data inserted successfully."
