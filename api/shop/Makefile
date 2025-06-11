# =================================================================
# Tools for setting up the execution environment
# =================================================================
.PHONY: setup-env install-tools
setup-env:
	@cp -p .env_sample .env
	@cp .env_localstack_sample .env_localstack

install-tools: setup-env
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
gen-api: bundle-openapi
	oapi-codegen -package gen -generate types -o internal/gen/types.gen.go ./spec/openapi.yaml
	oapi-codegen -package gen -generate strict-server,gin -templates ./spec/templates -o internal/gen/server.gen.go ./spec/openapi.yaml

bundle-openapi:
	redocly bundle ./spec/openapi_base.yaml --output ./spec/openapi.yaml

gen-sqlc:
	sqlc generate -f internal/repository/sqlc.yaml
	mockgen -source=./internal/repository/gen_sqlc/querier.go -package mock -destination=./internal/repository/gen_mock/mock_querier.go
	mockgen -source=./internal/repository/gen_sqlc/db.go -package mock -destination=./internal/repository/gen_mock/mock_db.go


# =================================================================
# Local execution environment setup
# =================================================================
.PHONY: lint deps build run
lint:
	golangci-lint run --timeout 3m

deps:
	go mod download && go mod tidy

build: deps
	go build -o build/shop_api cmd/main.go

run: build
	./build/shop_api


# =================================================================
# Container execution environment setup
# =================================================================
.PHONY: up down logs
up:
	docker compose up -d shop-api mysql localstack

down:
	docker compose down shop-api mysql localstack

logs:
	docker compose logs -f shop-api

# secret managerを操作する時のやつ
.PHONY: list-secrets get-secret-value
list-secrets:
	docker exec -it core-localstack awslocal secretsmanager list-secrets --region ap-northeast-1

get-secret-value:
	docker exec -it core-localstack awslocal secretsmanager get-secret-value --secret-id core/dev/rds-cluster --region ap-northeast-1


# =================================================================
# MySQL operations
# =================================================================
.PHONY: mysql
mysql:
	MYSQL_ROOT_PASSWORD=password#0 docker compose exec mysql mysql -u root -ppassword#0 -h localhost -P 33306 dev_core

# MySQL table migration
.PHONY: migrate-new migrate-up migrate-down migrate-status
migrate-new:
	sql-migrate new -env='dev' -config=./_tools/sql-migrate/config.yaml $(NAME)

migrate-up:
	sql-migrate up -env='dev' -config=./_tools/sql-migrate/config.yaml

migrate-down:
	sql-migrate down -limit=1 -env='dev' -config=./_tools/sql-migrate/config.yaml

migrate-status:
	sql-migrate status -env='dev' -config=./_tools/sql-migrate/config.yaml


# =================================================================
# Scripts
# =================================================================
.PHONY: seed-products

seed-products:
	@echo "Start seeding products data..."
	@bash ./scripts/seeds/products/insert.sh
	@echo "Seeding completed."

# =================================================================
# AWS resource operations
# =================================================================
VERSION := shop_api_v0.0.0

# ecr
.PHONY: auth push get-images delete-images
auth:
	aws ecr get-login-password --region ap-northeast-1 --profile ${AWS_PROFILE} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.ap-northeast-1.amazonaws.com

push: auth
	docker build --platform linux/amd64 --no-cache -t $(AWS_ACCOUNT_ID).dkr.ecr.ap-northeast-1.amazonaws.com/stg-shop-api:$(VERSION) -f ./build/Dockerfile.shop .
	docker push ${AWS_ACCOUNT_ID}.dkr.ecr.ap-northeast-1.amazonaws.com/stg-shop-api:$(VERSION)

get-images:
	aws ecr list-images --repository-name stg-shop-api --region ap-northeast-1 --profile ${AWS_PROFILE} --query 'imageIds[*]' | jq .

delete-images:
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
healthcheck:
	curl -i -X 'GET' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/healthcheck' \
		-H 'accept: application/json'

# User API
.PHONY: create-user get-me create-profile get-profile-me
create-user:
	curl -i -X 'POST' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/users' \
		-H 'accept: application/json' \
		-d ''

get-me:
	curl -i -X 'GET' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/users/me' \
		-H 'accept: application/json'

create-profile:
	curl -sX 'POST' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/users/profiles' \
		-H 'accept: application/json' \
		-H 'Content-Type: application/json' \
		-d '{"name": {"first_name": "智","last_name": "真皿","first_name_roman": "Satoshi","last_name_roman": "Masara"}, "address": { "region": "関東", "zip_code": "150-8377", "prefecture": "東京都", "city": "渋谷区", "street": "宇田川町", "other": "15番1号"}, "birthdate": "2000-01-01", "image_url": "https://example"}' | jq .

get-profile-me:
	curl -sX 'GET' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/users/profiles/me' \
		-H 'accept: application/json' | jq .

# Product API
.PHONY: get-products get-product-by-id
get-products:
	curl -sX 'GET' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/products?cursor=MjAwMDEwMDE%3D&limit=10' \
		-H 'accept: application/json' | jq .

get-product-by-id:
	curl -sX 'GET' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/products/20001001' \
		-H 'accept: application/json' | jq .

# External payment service customer information API
.PHONY: get-customer create-customer delete-customer
get-customer:
	curl -sX 'GET' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/payment/customers/10001001' \
		-H 'accept: application/json' | jq .

create-customer:
	curl -i -sX 'POST' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/payment/customers' \
		-H 'accept: application/json' \
		-d ''

delete-customer:
	curl -i -sX 'DELETE' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/payment/customers' \
		-H 'accept: */*'

# Card API
.PHONY: get-credit-cards create-credit-card delete-credit-card
get-credit-cards:
	curl -sX 'GET' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/payments/cards' \
		-H 'accept: application/json' | jq .

create-credit-card:
	curl -i -sX 'POST' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/payments/cards' \
		-H 'accept: */*' \
		-H 'Content-Type: application/json' \
		-d '{"token": "9f9213b2-9687-6910-d2ec-3a247582be2d", "is_default": true}'

delete-credit-card:
	curl -i -sX 'DELETE' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/payments/cards' \
		-H 'accept: */*'

# Reservation API
.PHONY: create-reservations
create-reservations:
	curl -i -sX 'POST' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/payments/reservations' \
		-H 'accept: application/json' \
		-H 'Content-Type: application/json' \
		-d '[{"product_id": 10001001, "quantity": 2}, {"product_id": 10001002, "quantity": 3}]'

# Charge API
.PHONY: create-charge get-charge-histories
create-charge:
	curl -i -sX 'POST' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/payments/charges' \
		-H 'accept: application/json' \
		-H 'Content-Type: application/json' \
		-d '{"reservation_id": "9f9213b2-9687-6910-d2ec-3a247582be2d"}'

get-charge-histories:
	curl -sX 'GET' \
		'http://${SHOP_API_LOCAL_HOST}:${SHOP_API_LOCAL_PORT}/shop/v1/payments/charges/histories?offset=0&limit=10' \
		-H 'accept: application/json' | jq .


# =================================================================
# API request operations (stg)
# =================================================================
AWS_API_DOMAIN := <api_domain>

stg-api-all-request: stg-healthcheck sleep \
	stg-create-user sleep \
	stg-get-me sleep \
	stg-create-reservations sleep \
	stg-create-charge sleep

.PHONY: stg-healthcheck
stg-healthcheck:
	curl -i -X 'GET' \
		'https://${AWS_API_DOMAIN}/shop/v1/healthcheck' \
		-H 'accept: application/json'

.PHONY: stg-create-user stg-get-me stg-create-product-comment
stg-create-user:
	curl -i -X 'POST' \
		'https://${AWS_API_DOMAIN}/shop/v1/users' \
		-H 'accept: application/json' \
		-d ''

stg-get-me:
	curl -i -X 'GET' \
		'https://${AWS_API_DOMAIN}/shop/v1/users/me' \
		-H 'accept: application/json'

.PHONY: stg-create-reservations stg-create-charge
stg-create-reservations:
	curl -i -sX 'POST' \
		'https://${AWS_API_DOMAIN}/shop/v1/payments/reservations' \
		-H 'accept: application/json' \
		-H 'Content-Type: application/json' \
		-d '[{"product_id": 10001001, "quantity": 2}, {"product_id": 10001002, "quantity": 3}]'

stg-create-charge:
	curl -i -sX 'POST' \
		'https://${AWS_API_DOMAIN}/shop/v1/payments/charges' \
		-H 'accept: application/json' \
		-H 'Content-Type: application/json' \
		-d '{"reservation_id": "9f9213b2-9687-6910-d2ec-3a247582be2d"}'
