## dev:

#### 1. 実行環境の設定

前提:
- docker compose で mysql DB が作成されるため、それ以降の作業になる。
- dev環境に関しては、Go製の sql-migrate を使用して schema を管理する。

#### 1. DB のマイグレーションを実行

```bash
$ make migrate-status
sql-migrate status -env='dev' -config=./_tools/sql-migrate/config.yaml
+------------------------------------------------------------+---------+
|                         MIGRATION                          | APPLIED |
+------------------------------------------------------------+---------+
| 20250611215221-create_users_table.sql                      | no      |
| 20250612015707-create_category_master_table.sql            | no      |
| 20250612015901-create_discount_master_table.sql            | no      |
| 20250612015948-create_products_table.sql                   | no      |
| 20250612020458-create_product_stocks_table.sql             | no      |
| 20250612020540-create_product_images_table.sql             | no      |
| 20250612020711-create_product_ratings_table.sql            | no      |
| 20250612033331-create_credit_cards_table.sql               | no      |
| 20250612034103-create_reservations_table.sql               | no      |
| 20250612034305-create_reservation_products_table.sql       | no      |
| 20250612034834-create_charges_table.sql                    | no      |
| 20250612034942-create_charge_products_table.sql            | no      |
| 20250612204610-create_payment_provider_customers_table.sql | no      |
+------------------------------------------------------------+---------+

$ make migrate-down
sql-migrate down -limit=1 -env='dev' -config=./_tools/sql-migrate/config.yaml
Applied 0 migrations

$ make migrate-up
sql-migrate up -env='dev' -config=./_tools/sql-migrate/config.yaml
Applied 13 migrations

$ make migrate-status
sql-migrate status -env='dev' -config=./_tools/sql-migrate/config.yaml
+------------------------------------------------------------+-------------------------------+
|                         MIGRATION                          |            APPLIED            |
+------------------------------------------------------------+-------------------------------+
| 20250611215221-create_users_table.sql                      | 2025-06-24 17:07:59 +0000 UTC |
| 20250612015707-create_category_master_table.sql            | 2025-06-24 17:07:59 +0000 UTC |
| 20250612015901-create_discount_master_table.sql            | 2025-06-24 17:07:59 +0000 UTC |
| 20250612015948-create_products_table.sql                   | 2025-06-24 17:07:59 +0000 UTC |
| 20250612020458-create_product_stocks_table.sql             | 2025-06-24 17:08:00 +0000 UTC |
| 20250612020540-create_product_images_table.sql             | 2025-06-24 17:08:00 +0000 UTC |
| 20250612020711-create_product_ratings_table.sql            | 2025-06-24 17:08:00 +0000 UTC |
| 20250612033331-create_credit_cards_table.sql               | 2025-06-24 17:08:00 +0000 UTC |
| 20250612034103-create_reservations_table.sql               | 2025-06-24 17:08:00 +0000 UTC |
| 20250612034305-create_reservation_products_table.sql       | 2025-06-24 17:08:00 +0000 UTC |
| 20250612034834-create_charges_table.sql                    | 2025-06-24 17:08:00 +0000 UTC |
| 20250612034942-create_charge_products_table.sql            | 2025-06-24 17:08:00 +0000 UTC |
| 20250612204610-create_payment_provider_customers_table.sql | 2025-06-24 17:08:00 +0000 UTC |
+------------------------------------------------------------+-------------------------------+
```

```sql
mysql> select database();
+------------+
| database() |
+------------+
| dev_core   |
+------------+
1 row in set (0.00 sec)

mysql> show tables;
+----------------------------+
| Tables_in_dev_core         |
+----------------------------+
| category_master            |
| charge_products            |
| charges                    |
| credit_cards               |
| discount_master            |
| gorp_migrations            |
| payment_provider_customers |
| product_images             |
| product_ratings            |
| product_stocks             |
| products                   |
| reservation_products       |
| reservations               |
| users                      |
+----------------------------+
14 rows in set (0.00 sec)
```


#### 2. 初期データを投入

```bash
# reset: データの全消去
$ make charge MYSQL_HOST=localhost MYSQL_PORT=33306 MYSQL_USER=root MYSQL_PASSWORD=password#0 MYSQL_DATABASE=dev_core
MYSQL_HOST=localhost MYSQL_PORT=33306 MYSQL_USER=root MYSQL_PASSWORD=password#0 MYSQL_DATABASE=dev_core bash ./scripts/seeds/reset/reset.sh
==============================================
Please specify the environment to reset:
  [dev] -> Docker Compose 経由
  [stg] -> 直接 MySQL へ接続
==============================================
Enter environment [dev/stg]: dev
==============================================
 Target Environment : dev
 Host               : localhost
 Port               : 33306
 User               : root
 Database           : dev_core
==============================================
Are you sure you want to reset the 'dev' database? (y/N): y
========================= [ Start truncating data ] =========================
Executing TRUNCATE script: ./scripts/seeds/reset/trancate.sql ...
WARN[0000] The "MYSQL_ROOT_PASSWORD" variable is not set. Defaulting to a blank string.
mysql: [Warning] Using a password on the command line interface can be insecure.
All tables truncated successfully.

# load: ユーザ、及び商品情報系のデータを投入
MYSQL_HOST=localhost MYSQL_PORT=33306 MYSQL_USER=root MYSQL_PASSWORD=password#0 MYSQL_DATABASE=dev_core bash ./scripts/seeds/loader/loader.sh
==============================================
Please specify the environment to insert seed data:
  [dev] -> Docker Compose 経由
  [stg] -> 直接 MySQL へ接続
==============================================
Enter environment [dev/stg]: dev
==============================================
 Target Environment : dev
 CONTAINER_NAME     : mysql
 MYSQL_USER         : root
 MYSQL_PASSWORD     : password#0
 MYSQL_DATABASE     : dev_core
 MYSQL_HOST         : localhost
 MYSQL_PORT         : 33306
==============================================
Are you sure you want to insert seed data into 'dev'? (y/N): y
Executing ./scripts/seeds/loader/users/01_users.sql ...
WARN[0000] The "MYSQL_ROOT_PASSWORD" variable is not set. Defaulting to a blank string.
mysql: [Warning] Using a password on the command line interface can be insecure.

...

Executing ./scripts/seeds/loader/payments/04_reservation_products.sql ...
WARN[0000] The "MYSQL_ROOT_PASSWORD" variable is not set. Defaulting to a blank string.
mysql: [Warning] Using a password on the command line interface can be insecure.
All seed data inserted successfully.

# charge: 決済、及び売上関連のデータ投入
MYSQL_HOST=localhost MYSQL_PORT=33306 MYSQL_USER=root MYSQL_PASSWORD=password#0 MYSQL_DATABASE=dev_core go run ./scripts/seeds/charge/main.go
2025/06/25 02:09:57 INFO ========================= [ Start charges script ] =========================
2025/06/25 02:09:57 INFO processing charge reservation_id=30000000-0000-0000-0000-000000000001
2025/06/25 02:09:57 INFO inserted charge_product charge_id=0197a2ea-f6d0-7259-8382-018f700fa589 product_id=10001002

...

2025/06/25 02:09:57 INFO processing charge reservation_id=30000000-0000-0000-0000-000000000049
2025/06/25 02:09:57 INFO inserted charge_product charge_id=0197a2ea-f93a-76af-a8f4-af6206da14b7 product_id=10001007
2025/06/25 02:09:57 INFO charge script completed
```

```sql
mysql> select * from users limit 3;
+--------------------------------------+----------+--------------------+---------+--------+---------------------+---------------------+---------------------+
| id                                   | username | email              | role    | status | last_login_at       | created_at          | updated_at          |
+--------------------------------------+----------+--------------------+---------+--------+---------------------+---------------------+---------------------+
| 00000000-0000-0000-0000-000000000002 | user02   | user02@example.com | general | active | 2025-06-24 17:09:55 | 2025-06-24 17:09:55 | 2025-06-24 17:09:55 |
| 00000000-0000-0000-0000-000000000003 | user03   | user03@example.com | general | active | 2025-06-24 17:09:55 | 2025-06-24 17:09:55 | 2025-06-24 17:09:55 |
| 00000000-0000-0000-0000-000000000004 | user04   | user04@example.com | general | active | 2025-06-24 17:09:55 | 2025-06-24 17:09:55 | 2025-06-24 17:09:55 |
+--------------------------------------+----------+--------------------+---------+--------+---------------------+---------------------+---------------------+
3 rows in set (0.00 sec)

mysql> select * from charges limit 3;
+--------------------------------------+--------------------------------------+--------------------------------------+--------+--------+---------------------+---------------------+---------------------+
| id                                   | reservation_id                       | user_id                              | amount | status | charged_at          | created_at          | updated_at          |
+--------------------------------------+--------------------------------------+--------------------------------------+--------+--------+---------------------+---------------------+---------------------+
| 0197a2ea-f6d0-7259-8382-018f700fa589 | 30000000-0000-0000-0000-000000000001 | 01975ff1-5ba9-73ca-be9a-75aa6bb00aaf |   2300 | paid   | 2025-06-24 17:09:57 | 2025-06-24 17:09:57 | 2025-06-24 17:09:57 |
| 0197a2ea-f6ef-7648-8988-49deb428e879 | 30000000-0000-0000-0000-000000000002 | 00000000-0000-0000-0000-000000000005 |   4000 | paid   | 2025-06-24 17:09:57 | 2025-06-24 17:09:57 | 2025-06-24 17:09:57 |
| 0197a2ea-f706-7c19-8682-45c9bc28b3cb | 30000000-0000-0000-0000-000000000004 | 00000000-0000-0000-0000-000000000010 |   1600 | paid   | 2025-06-24 17:09:57 | 2025-06-24 17:09:57 | 2025-06-24 17:09:57 |
+--------------------------------------+--------------------------------------+--------------------------------------+--------+--------+---------------------+---------------------+---------------------+
3 rows in set (0.00 sec)
```


## stg: 

#### 1. 実行環境の準備
```bash
# RDS instance の状態確認
$ make stg-describe-db-instances AWS_PROFILE=$(AWS_PROFILE)

# RDS Proxy の状態確認
$ make stg-describe-db-proxy-targets AWS_PROFILE=$(AWS_PROFILE)

# ssm で踏み台へアクセス
$ make ssm-start-session AWS_PROFILE=$(AWS_PROFILE) TARGET_ID=$(TARGET_ID)

# Goのパス設定
$ export PATH=$PATH:/usr/local/go/bin

# Goスクリプト実行に必要なディレクトリ群を作成し、権限の割り当て
$ sudo mkdir -p /home/ssm-user/go /home/ssm-user/.cache
$ sudo chown -R ssm-user:ssm-user /home/ssm-user/go
$ sudo chown -R ssm-user:ssm-user /home/ssm-user/.cache

# プロジェクトのルートディレクトリへ移動
$ cd /home/ssm-user/workspace/data_pipeline_sample/api/shop/
```

```bash
# RDS Proxy を経由して DB へアクセス
$ mysql -h $(RDS_PROXY_HOST_NAME) -P 3306 -u core -ppassword -D stg_core
```
```sql
mysql> select database();
+------------+
| database() |
+------------+
| stg_core   |
+------------+
1 row in set (0.00 sec)

mysql> show tables;
Empty set (0.00 sec)
```

#### 2. DB のマイグレーションを実行


down:
```bash
$ make stg-migrate-down MYSQL_HOST=$(RDS_PROXY_HOST_NAME) MYSQL_PORT=3306 MYSQL_USER=core MYSQL_PASSWORD='password' MYSQL_DATABASE=stg_core
```

up:
```bash
$ make stg-migrate-up MYSQL_HOST=$(RDS_PROXY_HOST_NAME) MYSQL_PORT=3306 MYSQL_USER=core MYSQL_PASSWORD='password' MYSQL_DATABASE=stg_core
```

```sql
mysql> show tables;
+----------------------------+
| Tables_in_stg_core         |
+----------------------------+
| category_master            |
| charge_products            |
| charges                    |
| credit_cards               |
| discount_master            |
| payment_provider_customers |
| product_images             |
| product_ratings            |
| product_stocks             |
| products                   |
| reservation_products       |
| reservations               |
| users                      |
+----------------------------+
13 rows in set (0.01 sec)
```

#### 3. 初期データを投入

workディレクトリに移動
```bash
cd /home/ssm-user/workspace/data_pipeline_sample/
```

データ投入スクリプトを実行
```bash
$ make charge MYSQL_HOST=$(RDS_PROXY_HOST_NAME) MYSQL_PORT=3306 MYSQL_USER=core MYSQL_PASSWORD='password' MYSQL_DATABASE=stg_core
```

sample
```bash
$ make charge MYSQL_HOST=$(RDS_PROXY_HOST_NAME) MYSQL_PORT=3306 MYSQL_USER=core MYSQL_PASSWORD='password' MYSQL_DATABASE=stg_core
# reset: データの全消去
MYSQL_HOST=$(RDS_PROXY_HOST_NAME) MYSQL_PORT=3306 MYSQL_USER=core MYSQL_PASSWORD=password MYSQL_DATABASE=stg_core bash ./scripts/seeds/reset/reset.sh
==============================================
Please specify the environment to reset:
  [dev] -> Docker Compose 経由
  [stg] -> 直接 MySQL へ接続
==============================================
Enter environment [dev/stg]: stg
==============================================
 Target Environment : stg
 Host               : $(RDS_PROXY_HOST_NAME)
 Port               : 3306
 User               : core
 Database           : stg_core
==============================================
Are you sure you want to reset the 'stg' database? (y/N): y
========================= [ Start truncating data ] =========================
Executing TRUNCATE script: ./scripts/seeds/reset/trancate.sql ...
mysql: [Warning] Using a password on the command line interface can be insecure.
All tables truncated successfully.
```

```bash
# load: ユーザ、及び商品情報系のデータを投入
MYSQL_HOST=$(RDS_PROXY_HOST_NAME) MYSQL_PORT=3306 MYSQL_USER=core MYSQL_PASSWORD=password MYSQL_DATABASE=stg_core bash ./scripts/seeds/loader/loader.sh
==============================================
Please specify the environment to insert seed data:
  [dev] -> Docker Compose 経由
  [stg] -> 直接 MySQL へ接続
==============================================
Enter environment [dev/stg]: stg
==============================================
 Target Environment : stg
 CONTAINER_NAME     : mysql
 MYSQL_USER         : core
 MYSQL_PASSWORD     : password
 MYSQL_DATABASE     : stg_core
 MYSQL_HOST         : $(RDS_PROXY_HOST_NAME)
 MYSQL_PORT         : 3306
==============================================
Are you sure you want to insert seed data into 'stg'? (y/N): y
Executing ./scripts/seeds/loader/users/01_users.sql ...
mysql: [Warning] Using a password on the command line interface can be insecure.

...

Executing ./scripts/seeds/loader/payments/04_reservation_products.sql ...
mysql: [Warning] Using a password on the command line interface can be insecure.
All seed data inserted successfully.

# charge: 決済、及び売上関連のデータ投入
MYSQL_HOST=$(RDS_PROXY_HOST_NAME) MYSQL_PORT=3306 MYSQL_USER=core MYSQL_PASSWORD=password MYSQL_DATABASE=stg_core go run ./scripts/seeds/charge/main.go
go: downloading github.com/go-sql-driver/mysql v1.9.2
go: downloading github.com/google/uuid v1.5.0
go: downloading filippo.io/edwards25519 v1.1.0
2025/06/24 13:27:59 INFO ========================= [ Start charges script ] =========================
2025/06/24 13:28:00 INFO processing charge reservation_id=30000000-0000-0000-0000-000000000001
2025/06/24 13:28:00 INFO inserted charge_product charge_id=0197a21f-c3da-73a4-9e8c-8c7a32fa3ccf product_id=10001002

...

2025/06/24 13:28:02 INFO processing charge reservation_id=30000000-0000-0000-0000-000000000049
2025/06/24 13:28:02 INFO inserted charge_product charge_id=0197a21f-cda9-76d7-98ca-a011bd080a43 product_id=10001007
2025/06/24 13:28:02 INFO charge script completed
```
