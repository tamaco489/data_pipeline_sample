### stg環境向けスクリプト

1. DB のマイグレーションを実行

up:
```bash
$ make stg-migrate-down MYSQL_HOST=127.0.0.1 MYSQL_PORT=33306 MYSQL_USER=root MYSQL_PASSWORD=password#0 MYSQL_DATABASE=dev_core
Start rolling back stg...
mysql -h 127.0.0.1 -P 33306 -u root -ppassword#0 dev_core < scripts/seeds/migrate/down.sql
mysql: [Warning] Using a password on the command line interface can be insecure.
Rolling back stg completed.
```

down:
```bash
$ make stg-migrate-up MYSQL_HOST=127.0.0.1 MYSQL_PORT=33306 MYSQL_USER=root MYSQL_PASSWORD=password#0 MYSQL_DATABASE=dev_core  
Start migrating stg...
mysql -h 127.0.0.1 -P 33306 -u root -ppassword#0 dev_core < scripts/seeds/migrate/up.sql
mysql: [Warning] Using a password on the command line interface can be insecure.
Migrating stg completed.
```
