#!/bin/bash
# scripts/seeds/reset/reset.sh

set -e

CONTAINER_NAME="mysql"
MYSQL_HOST="${MYSQL_HOST}"
MYSQL_PORT="${MYSQL_PORT:-33306}"
MYSQL_USER="${MYSQL_USER}"
MYSQL_PASSWORD="${MYSQL_PASSWORD}"
MYSQL_DATABASE="${MYSQL_DATABASE}"

SQL_FILE="./scripts/seeds/reset/trancate.sql"

echo "========================= [ Start truncating data ] ========================="
echo "Executing TRUNCATE script: ${SQL_FILE} ..."
docker compose exec -T $CONTAINER_NAME \
  mysql -h"$MYSQL_HOST" -P"$MYSQL_PORT" \
  -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" < "$SQL_FILE"

echo "All tables truncated successfully."
