## stg環境向けスクリプト

#### 1. DB のマイグレーションを実行

up:
```bash
$ make stg-migrate-down MYSQL_HOST=127.0.0.1 MYSQL_PORT=33306 MYSQL_USER=root MYSQL_PASSWORD=password#0 MYSQL_DATABASE=dev_core
```

down:
```bash
$ make stg-migrate-up MYSQL_HOST=127.0.0.1 MYSQL_PORT=33306 MYSQL_USER=root MYSQL_PASSWORD=password#0 MYSQL_DATABASE=dev_core  
```

#### 2. 初期データを投入

```bash
$ make charge MYSQL_HOST=localhost MYSQL_PORT=33306 MYSQL_USER=root MYSQL_PASSWORD=password#0 MYSQL_DATABASE=dev_core
```
