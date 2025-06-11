#!/bin/bash

# .env_localstack の値を読み込む
set -a # 以降の環境変数の自動エクスポートを有効化
source /etc/localstack/init/ready.d/.env_localstack
set +a # 自動エクスポートを無効化

# Secrets Manager にシークレットを作成
awslocal secretsmanager create-secret \
  --name 'core/dev/rds-cluster' \
  --region ap-northeast-1 \
  --secret-string "{
    \"username\":\"${MYSQL_USERNAME}\",
    \"password\":\"${MYSQL_PASSWORD}\",
    \"host\":\"${MYSQL_HOST}\",
    \"port\":\"${MYSQL_PORT}\",
    \"dbname\":\"${MYSQL_DATABASE}\"
  }"
