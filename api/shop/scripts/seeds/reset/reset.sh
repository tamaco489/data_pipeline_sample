#!/bin/bash
# scripts/seeds/reset/reset.sh

set -e

CONTAINER_NAME="mysql"
MYSQL_USER="root"
MYSQL_PASSWORD="password#0"
MYSQL_DATABASE="dev_core"
MYSQL_HOST="localhost"
MYSQL_PORT=33306

SQL_FILE="./scripts/seeds/reset/trancate.sql"

echo "Executing TRUNCATE script: ${SQL_FILE} ..."
docker compose exec -T $CONTAINER_NAME mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" < "$SQL_FILE"

echo "All tables truncated successfully."
