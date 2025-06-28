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

```sql
mysql> select * from reservations order by id desc limit 3;
+--------------------------------------+--------------------------------------+---------------------+---------------------+-----------+---------------------+---------------------+
| id                                   | user_id                              | reserved_at         | expired_at          | status    | created_at          | updated_at          |
+--------------------------------------+--------------------------------------+---------------------+---------------------+-----------+---------------------+---------------------+
| 30000000-0000-0000-0000-000000000050 | 00000000-0000-0000-0000-000000000005 | 2025-06-12 14:05:00 | 2025-06-12 14:20:00 | pending   | 2025-06-12 14:05:00 | 2025-06-12 14:05:00 |
| 30000000-0000-0000-0000-000000000049 | 01975ff1-5ba9-73ca-be9a-75aa6bb00aaf | 2025-06-12 14:00:00 | 2025-06-12 14:15:00 | confirmed | 2025-06-12 14:00:00 | 2025-06-12 14:00:00 |
| 30000000-0000-0000-0000-000000000048 | 00000000-0000-0000-0000-000000000014 | 2025-06-12 13:55:00 | 2025-06-12 14:10:00 | confirmed | 2025-06-12 13:55:00 | 2025-06-12 13:55:00 |
+--------------------------------------+--------------------------------------+---------------------+---------------------+-----------+---------------------+---------------------+
3 rows in set (0.01 sec)

mysql> select * from charges order by id desc limit 3;
+--------------------------------------+--------------------------------------+--------------------------------------+--------+--------+---------------------+---------------------+---------------------+
| id                                   | reservation_id                       | user_id                              | amount | status | charged_at          | created_at          | updated_at          |
+--------------------------------------+--------------------------------------+--------------------------------------+--------+--------+---------------------+---------------------+---------------------+
| 88603b81-bb62-480b-8be3-15a8c6ee3c7a | 0197b73c-2920-75a9-9941-1a66ffb59f09 | 01975ff1-5ba9-73ca-be9a-75aa6bb00aaf |   5000 | unpaid | NULL                | 2025-06-28 15:51:36 | 2025-06-28 15:51:36 |
| 0197b682-bed8-7670-a7dd-44715ccd710c | 30000000-0000-0000-0000-000000000049 | 01975ff1-5ba9-73ca-be9a-75aa6bb00aaf |   1600 | paid   | 2025-06-28 12:28:31 | 2025-06-28 12:28:31 | 2025-06-28 12:28:31 |
| 0197b682-beb8-7253-959f-6a672b9dcbbe | 30000000-0000-0000-0000-000000000048 | 00000000-0000-0000-0000-000000000014 |    700 | paid   | 2025-06-28 12:28:31 | 2025-06-28 12:28:31 | 2025-06-28 12:28:31 |
+--------------------------------------+--------------------------------------+--------------------------------------+--------+--------+---------------------+---------------------+---------------------+
3 rows in set (0.00 sec)
```