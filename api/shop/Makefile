# =================================================================
# Tools for setting up the execution environment
# =================================================================
.PHONY: setup-env install-tools
setup-env: ## 環境変数の設定
	@cp -p .env_sample .env
	@cp .env_localstack_sample .env_localstack

install-tools: setup-env ## プロジェクトで使用するツールのインストール
	go install github.com/deepmap/oapi-codegen/cmd/oapi-codegen@latest
	go install golang.org/x/tools/cmd/godoc@latest
	go install github.com/rubenv/sql-migrate/...@latest
	go install github.com/sqlc-dev/sqlc/cmd/sqlc@latest
	go install go.uber.org/mock/mockgen@latest
	npm i -g @redocly/cli@latest


# =================================================================
# Generate Open API files and SQLC files
# =================================================================
.PHONY: gen-api bundle-openapi
gen-api: bundle-openapi ## Open APIのschemaをもとに、APIサーバインターフェース、及び型定義を生成
	oapi-codegen -package gen -generate types -o internal/gen/types.gen.go ./spec/openapi.yaml
	oapi-codegen -package gen -generate strict-server,gin -templates ./spec/templates -o internal/gen/server.gen.go ./spec/openapi.yaml

bundle-openapi: ## Open APIのファイルを統合
	redocly bundle ./spec/openapi_base.yaml --output ./spec/openapi.yaml

gen-sqlc: ## SQLCのファイルを生成
	sqlc generate -f internal/repository/sqlc.yaml
	mockgen -source=./internal/repository/gen_sqlc/querier.go -package mock -destination=./internal/repository/gen_mock/mock_querier.go
	mockgen -source=./internal/repository/gen_sqlc/db.go -package mock -destination=./internal/repository/gen_mock/mock_db.go


# =================================================================
# Local execution environment setup
# =================================================================
.PHONY: lint deps build run
lint: ## コードの静的解析
	golangci-lint run --timeout 3m

deps: ## 依存パッケージのダウンロード
	go mod download && go mod tidy

build: deps
	go build -o build/shop_api cmd/main.go

run: build
	./build/shop_api


# =================================================================
# Container execution environment setup
# =================================================================
.PHONY: up down logs
up: ## コンテナの起動
	docker compose up -d shop-api mysql localstack

down: ## コンテナの停止
	docker compose down shop-api mysql localstack

logs: ## コンテナのログを表示
	docker compose logs -f shop-api


# =================================================================
# MySQL operations
# =================================================================
.PHONY: mysql
mysql: ## MySQLのコンテナを起動
	MYSQL_ROOT_PASSWORD=password#0 docker compose exec mysql mysql -u root -ppassword#0 -h localhost -P 33306 dev_core

# MySQL table migration
.PHONY: migrate-new migrate-up migrate-down migrate-status
migrate-new: ## 新しいマイグレーションファイルを作成
	sql-migrate new -env='dev' -config=./_tools/sql-migrate/config.yaml $(NAME)

migrate-up: ## マイグレーションを適用
	sql-migrate up -env='dev' -config=./_tools/sql-migrate/config.yaml

migrate-down: ## マイグレーションをロールバック
	sql-migrate down -limit=1 -env='dev' -config=./_tools/sql-migrate/config.yaml

migrate-status: ## マイグレーションの状態を表示
	sql-migrate status -env='dev' -config=./_tools/sql-migrate/config.yaml


# =================================================================
# Scripts
# =================================================================
.PHONY: reset load
reset: ## DBデータのリセット
	MYSQL_HOST=$(MYSQL_HOST) MYSQL_PORT=$(MYSQL_PORT) MYSQL_USER=$(MYSQL_USER) MYSQL_PASSWORD=$(MYSQL_PASSWORD) MYSQL_DATABASE=$(MYSQL_DATABASE) bash ./scripts/seeds/reset/reset.sh

load: reset ## DBデータの初期化
	MYSQL_HOST=$(MYSQL_HOST) MYSQL_PORT=$(MYSQL_PORT) MYSQL_USER=$(MYSQL_USER) MYSQL_PASSWORD=$(MYSQL_PASSWORD) MYSQL_DATABASE=$(MYSQL_DATABASE) bash ./scripts/seeds/loader/loader.sh

charge: load ## 決済処理データの初期化
	MYSQL_HOST=$(MYSQL_HOST) MYSQL_PORT=$(MYSQL_PORT) MYSQL_USER=$(MYSQL_USER) MYSQL_PASSWORD=$(MYSQL_PASSWORD) MYSQL_DATABASE=$(MYSQL_DATABASE) go run ./scripts/seeds/charge/main.go

# stg向け
.PHONY: stg-migrate-up stg-migrate-down
stg-migrate-up: ## stg: マイグレーションを適用
	mysql -h $(MYSQL_HOST) -P $(MYSQL_PORT) -u $(MYSQL_USER) -p$(MYSQL_PASSWORD) $(MYSQL_DATABASE) < scripts/seeds/migrate/up.sql

stg-migrate-down: ## stg: マイグレーションをロールバック
	mysql -h $(MYSQL_HOST) -P $(MYSQL_PORT) -u $(MYSQL_USER) -p$(MYSQL_PASSWORD) $(MYSQL_DATABASE) < scripts/seeds/migrate/down.sql


# =================================================================
# AWS resource operations
# =================================================================
VERSION := shop_api_v0.0.0

# ecr
.PHONY: auth push get-images delete-images
auth: ## ECRの認証
	aws ecr get-login-password --region ap-northeast-1 --profile ${AWS_PROFILE} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.ap-northeast-1.amazonaws.com

push: auth ## ECRにイメージをpush
	docker build --platform linux/amd64 --no-cache -t $(AWS_ACCOUNT_ID).dkr.ecr.ap-northeast-1.amazonaws.com/stg-shop-api:$(VERSION) -f ./build/Dockerfile.shop .
	docker push ${AWS_ACCOUNT_ID}.dkr.ecr.ap-northeast-1.amazonaws.com/stg-shop-api:$(VERSION)

get-images: ## ECRのイメージを一覧表示
	aws ecr list-images --repository-name stg-shop-api --region ap-northeast-1 --profile ${AWS_PROFILE} --query 'imageIds[*]' | jq .

delete-images: ## ECRのイメージを削除
	@aws ecr list-images --repository-name stg-shop-api --region ap-northeast-1 --profile ${AWS_PROFILE} --query 'imageIds[*]' --output json > /tmp/images.json
	@cat /tmp/images.json | jq -c '.[]' | while read -r image_id; do \
		aws ecr batch-delete-image --repository-name stg-shop-api --region ap-northeast-1 --profile ${AWS_PROFILE} --image-ids $${image_id}; \
	done | jq .

# lambda
.PHONY: deploy
deploy: push
	aws lambda update-function-code  --profile ${AWS_PROFILE} \
		--function-name stg-shop-api \
		--image-uri $(AWS_ACCOUNT_ID).dkr.ecr.ap-northeast-1.amazonaws.com/stg-shop-api:$(VERSION) | jq .

# ssm
.PHONY: ssm-start-session
ssm-start-session:
	aws ssm start-session --profile ${AWS_PROFILE} --region ap-northeast-1 --target $(TARGET_ID)

# secrets manager
.PHONY: dev-get-secret-list dev-get-secret-value stg-get-secret-value stg-force-delete-secret
dev-get-secret-list: ## dev: シークレットマネージャーのシークレットを一覧表示
	docker exec -it core-localstack awslocal secretsmanager list-secrets --region ap-northeast-1

dev-get-secret-value: ## dev: シークレットマネージャーのシークレットを取得
	docker exec -it core-localstack awslocal secretsmanager get-secret-value --secret-id core/dev/rds-cluster --region ap-northeast-1

stg-get-secret-value: ## stg: シークレットマネージャーのシークレットを取得
	aws secretsmanager get-secret-value --region ap-northeast-1 --profile ${AWS_PROFILE} --secret-id $(SECRET_ID) | jq .

stg-force-delete-secret: ## stg: シークレットマネージャーのシークレットを強制的に削除
	aws secretsmanager delete-secret \
		--profile ${AWS_PROFILE} \
		--region ap-northeast-1 \
		--secret-id $(SECRET_ID) \
		--force-delete-without-recovery | jq .

# rds
.PHONY: stg-describe-db-instances stg-describe-db-proxy-targets
stg-describe-db-instances: ## stg: RDSの情報を取得
	aws rds describe-db-instances --db-instance-identifier stg-data-pipeline-sample-core-db-instance-1 --profile ${AWS_PROFILE} --region ap-northeast-1 | jq .

stg-describe-db-proxy-targets: ## stg: RDS Proxyの情報を取得
	aws rds describe-db-proxy-targets --profile ${AWS_PROFILE} --region ap-northeast-1 --db-proxy-name stg-data-pipeline-sample-core-db-proxy | jq .


# =================================================================
# API request operations (dev)
# =================================================================
.PHONY: api-all-request
sleep:
	@sleep 0.1

api-all-request: healthcheck sleep \
	create-user sleep \
	get-me sleep \
	create-profile sleep \
	get-profile-me sleep \
	get-products sleep \
	get-product-by-id sleep \
	get-credit-cards sleep \
	create-credit-card sleep \
	delete-credit-card sleep \
	create-reservations sleep \
	create-charge sleep \
	get-charge-histories sleep \
	get-customer sleep \
	create-customer sleep \
	delete-customer sleep

SHOP_API_LOCAL_HOST := localhost
SHOP_API_LOCAL_PORT := 8080

.PHONY: healthcheck
healthcheck: ## dev: healthcheck APIのリクエスト
	curl -i -X 'GET' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/healthcheck' \
		-H 'accept: application/json'

# User API
.PHONY: create-user get-me create-profile get-profile-me
create-user: ## dev: ユーザーの作成
	curl -i -X 'POST' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/users' \
		-H 'accept: application/json' \
		-d ''

get-me: ## dev: ユーザーの情報を取得
	curl -i -X 'GET' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/users/me' \
		-H 'accept: application/json'

create-profile: ## dev: ユーザーのプロフィールを作成
	curl -sX 'POST' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/users/profiles' \
		-H 'accept: application/json' \
		-H 'Content-Type: application/json' \
		-d '{"name": {"first_name": "智","last_name": "真皿","first_name_roman": "Satoshi","last_name_roman": "Masara"}, "address": { "region": "関東", "zip_code": "150-8377", "prefecture": "東京都", "city": "渋谷区", "street": "宇田川町", "other": "15番1号"}, "birthdate": "2000-01-01", "image_url": "https://example"}' | jq .

get-profile-me: ## dev: ユーザーのプロフィールを取得
	curl -sX 'GET' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/users/profiles/me' \
		-H 'accept: application/json' | jq .

# Product API
.PHONY: get-products get-product-by-id
get-products: ## dev: 商品の一覧を取得
	curl -sX 'GET' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/products?cursor=MjAwMDEwMDE%3D&limit=10' \
		-H 'accept: application/json' | jq .

get-product-by-id: ## dev: 商品の詳細を取得
	curl -sX 'GET' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/products/10001002' \
		-H 'accept: application/json' | jq .

# External payment service customer information API
.PHONY: get-customer create-customer delete-customer
get-customer: ## dev: 顧客の情報を取得
	curl -sX 'GET' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/payment/customers/10001001' \
		-H 'accept: application/json' | jq .

create-customer: ## dev: 顧客の情報を作成
	curl -i -sX 'POST' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/payment/customers' \
		-H 'accept: application/json' \
		-d ''

delete-customer: ## dev: 顧客の情報を削除
	curl -i -sX 'DELETE' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/payment/customers' \
		-H 'accept: */*'

# Card API
.PHONY: get-credit-cards create-credit-card delete-credit-card
get-credit-cards: ## dev: クレジットカードの一覧を取得
	curl -sX 'GET' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/payments/cards' \
		-H 'accept: application/json' | jq .

create-credit-card: ## dev: クレジットカードの情報を作成
	curl -i -sX 'POST' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/payments/cards' \
		-H 'accept: */*' \
		-H 'Content-Type: application/json' \
		-d '{"token": "9f9213b2-9687-6910-d2ec-3a247582be2d", "is_default": true}'

delete-credit-card: ## dev: クレジットカードの情報を削除
	curl -i -sX 'DELETE' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/payments/cards' \
		-H 'accept: */*'

# Reservation API
.PHONY: create-reservations
create-reservations: ## dev: 予約の情報を作成
	curl -i -sX 'POST' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/payments/reservations' \
		-H 'accept: application/json' \
		-H 'Content-Type: application/json' \
		-d '[{"product_id": 10001001, "quantity": 1}, {"product_id": 10001003, "quantity": 1}, {"product_id": 10001009, "quantity": 3}, {"product_id": 10001014, "quantity": 2}]'

# Charge API
.PHONY: create-charge get-charge-histories
# sample: make create-charge RESERVATION_ID=01976fe3-e429-7803-bfdc-fa4216f0c6b0
create-charge: ## dev: 決済の情報を作成
	curl -i -sX 'POST' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/payments/charges' \
		-H 'accept: application/json' \
		-H 'Content-Type: application/json' \
		-d '{"reservation_id": "$(RESERVATION_ID)"}'

get-charge-histories:
	curl -sX 'GET' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/payments/charges/histories?offset=0&limit=10' \
		-H 'accept: application/json' | jq .


# =================================================================
# API request operations (stg)
# =================================================================
stg-api-all-request: stg-healthcheck sleep \
	stg-create-user sleep \
	stg-get-me sleep \
	stg-create-reservations sleep \
	stg-create-charge sleep

.PHONY: stg-healthcheck
# sample: make stg-healthcheck API_DOMAIN=api.domain_name.com
stg-healthcheck: ## stg: healthcheck APIのリクエスト
	curl -i -X 'GET' \
		'https://$(API_DOMAIN)/shop/v1/healthcheck' \
		-H 'accept: application/json'

.PHONY: stg-create-user stg-get-me stg-create-product-comment
stg-create-user: ## stg: ユーザーの作成
	curl -i -X 'POST' \
		'https://$(API_DOMAIN)/shop/v1/users' \
		-H 'accept: application/json' \
		-d ''

stg-get-me: ## stg: ユーザーの情報を取得
	curl -i -X 'GET' \
		'https://$(API_DOMAIN)/shop/v1/users/me' \
		-H 'accept: application/json'

.PHONY: stg-create-reservations stg-create-charge
stg-create-reservations:
	curl -i -sX 'POST' \
		'https://$(API_DOMAIN)/shop/v1/payments/reservations' \
		-H 'accept: application/json' \
		-H 'Content-Type: application/json' \
		-d '[{"product_id": 10001001, "quantity": 2}, {"product_id": 10001002, "quantity": 3}]'

stg-create-charge: ## stg: 決済の情報を作成
	curl -i -sX 'POST' \
		'https://$(API_DOMAIN)/shop/v1/payments/charges' \
		-H 'accept: application/json' \
		-H 'Content-Type: application/json' \
		-d '{"reservation_id": "9f9213b2-9687-6910-d2ec-3a247582be2d"}'


# =================================================================
# General
# =================================================================
.PHONY: help
help: ## ヘルプ
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
