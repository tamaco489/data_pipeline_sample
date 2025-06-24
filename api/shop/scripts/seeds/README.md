## stg環境向けスクリプト

#### 1. 実行環境の準備
```bash
# RDS instance の状態確認
$ make stg-describe-db-instances AWS_PROFILE=$(AWS_PROFILE)

# RDS Proxy の状態確認
$ make stg-describe-db-proxy-targets AWS_PROFILE=$(AWS_PROFILE)

# ssm で踏み台へアクセス
$ make ssm-start-session AWS_PROFILE=$(AWS_PROFILE) TARGET_ID=$(TARGET_ID)

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

スクリプト実行環境設定
```bash
# Goのパス設定
$ export PATH=$PATH:/usr/local/go/bin

# Goスクリプト実行に必要なディレクトリ群を作成し、権限の割り当て
$ sudo mkdir -p /home/ssm-user/go /home/ssm-user/.cache
$ sudo chown -R ssm-user:ssm-user /home/ssm-user/go
$ sudo chown -R ssm-user:ssm-user /home/ssm-user/.cache
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
