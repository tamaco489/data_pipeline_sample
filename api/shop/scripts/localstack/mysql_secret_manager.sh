#!/bin/bash

# Load values from .env_localstack
set -a # Enable automatic export of environment variables
source /etc/localstack/init/ready.d/.env_localstack
set +a # Disable automatic export of environment variables

# Create a secret in Secrets Manager
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
