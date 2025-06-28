## shop api

stg:
---

healthcheck api
```bash
$ make stg-healthcheck API_DOMAIN=api.xxx.xxx@exmple.com
curl -i -X 'GET' \
        'https://api.xxx.xxx@exmple.com/shop/v1/healthcheck' \
        -H 'accept: application/json'
HTTP/2 200
date: Sat, 28 Jun 2025 15:54:51 GMT
content-type: application/json
content-length: 17
apigw-requestid: M4d70iX7tjMEJ0Q=

{"message":"OK"}
```
get me api
```bash
$ make stg-get-me API_DOMAIN=api.xxx.xxx@exmple.com
curl -i -X 'GET' \
        'https://api.xxx.xxx@exmple.com/shop/v1/users/me' \
        -H 'accept: application/json'
HTTP/2 200
date: Sat, 28 Jun 2025 13:25:35 GMT
content-type: application/json
content-length: 47
apigw-requestid: M4IEYhT3tjMEJIg=

{"uid":"01975ff1-5ba9-73ca-be9a-75aa6bb00aaf"}
```

create reservations api
```bash
$ make stg-create-reservations API_DOMAIN=api.xxx.xxx@exmple.com
curl -i -sX 'POST' \
        'https://api.xxx.xxx@exmple.com/shop/v1/payments/reservations' \
        -H 'accept: application/json' \
        -H 'Content-Type: application/json' \
        -d '[{"product_id": 10001001, "quantity": 1}, {"product_id": 10001003, "quantity": 1}, {"product_id": 10001009, "quantity": 3}, {"product_id": 10001014, "quantity": 2}]'
HTTP/2 201
date: Sat, 28 Jun 2025 15:51:02 GMT
content-type: application/json
content-length: 58
apigw-requestid: M4dYAjaVNjMEPpQ=

{"reservation_id":"0197b73c-2920-75a9-9941-1a66ffb59f09"}
```

create charge api
```bash
$ make stg-create-charge API_DOMAIN=api.xxx.xxx@exmple.com RESERVATION_ID=0197b73c-2920-75a9-9941-1a66ffb59f09
curl -i -sX 'POST' \
        'https://api.xxx.xxx@exmple.com/shop/v1/payments/charges' \
        -H 'accept: application/json' \
        -H 'Content-Type: application/json' \
        -d '{"reservation_id": "0197b73c-2920-75a9-9941-1a66ffb59f09"}'
HTTP/2 204
date: Sat, 28 Jun 2025 15:51:36 GMT
apigw-requestid: M4ddKjrcNjMEPRQ=
```