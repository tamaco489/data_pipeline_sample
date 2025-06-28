#!/bin/bash
# scripts/seeds/reset/reset.sh

set -e

# ========== Prompt user for environment ==========

echo "=============================================="
echo "Please specify the environment to reset:"
echo "  [dev] -> Docker Compose 経由"
echo "  [stg] -> 直接 MySQL へ接続"
echo "=============================================="

read -p "Enter environment [dev/stg]: " ENVIRONMENT

if [[ "$ENVIRONMENT" != "dev" && "$ENVIRONMENT" != "stg" ]]; then
  echo "[ERROR] Invalid environment: ${ENVIRONMENT}. Allowed values are 'dev' or 'stg'."
  exit 1
fi

MYSQL_HOST="${MYSQL_HOST}"
MYSQL_PORT="${MYSQL_PORT:-33306}"
MYSQL_USER="${MYSQL_USER}"
MYSQL_PASSWORD="${MYSQL_PASSWORD}"
MYSQL_DATABASE="${MYSQL_DATABASE}"

SQL_FILE="./scripts/seeds/reset/trancate.sql"

echo "=============================================="
echo " Target Environment : ${ENVIRONMENT}"
echo " Host               : ${MYSQL_HOST}"
echo " Port               : ${MYSQL_PORT}"
echo " User               : ${MYSQL_USER}"
echo " Database           : ${MYSQL_DATABASE}"
echo "=============================================="

# === Confirm ===
read -p "Are you sure you want to reset the '${ENVIRONMENT}' database? (y/N): " CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo "Cancelled."
  exit 1
fi

echo "========================= [ Start truncating data ] ========================="
echo "Executing TRUNCATE script: ${SQL_FILE} ..."

if [ "$ENVIRONMENT" = "dev" ]; then
  # dev: via docker compose
  CONTAINER_NAME="mysql"
  docker compose exec -T $CONTAINER_NAME \
    mysql -h"$MYSQL_HOST" -P"$MYSQL_PORT" \
    -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" < "$SQL_FILE"

elif [ "$ENVIRONMENT" = "stg" ]; then
  # stg: directly execute
  mysql -h"$MYSQL_HOST" -P"$MYSQL_PORT" \
    -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" < "$SQL_FILE"
fi

echo "All tables truncated successfully."
