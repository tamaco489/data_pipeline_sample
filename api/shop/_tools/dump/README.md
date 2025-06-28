## stg_dump

Instructions for dumping data from AWS RDS and outputting it to the local environment.
Note: Two terminals are required.

1. terminal_1: Execute port forwarding
```bash
$ make stg-core-port-forward AWS_PROFILE=xxxxxxxxxxxx TARGET_ID=i-xxxxxxxxxxxxxxxxx DB_PROXY_HOST=stg-data-pipeline-sample-core-db-proxy.proxy-xxxxxxxxxxxx.ap-northeast-1.rds.amazonaws.com
aws ssm start-session --profile xxxxxxxxxxxx --region ap-northeast-1 --target i-xxxxxxxxxxxxxxxxx --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters host=stg-data-pipeline-sample-core-db-proxy.proxy-xxxxxxxxxxxx.ap-northeast-1.rds.amazonaws.com,portNumber="3306",localPortNumber="13306"

Starting session with SessionId: xxxxxxxxxxxx-j24sdsfnpuofi8fx2n9sdvvig8
```

2. terminal_2: Execute ping command to the forwarded port to verify connection.
```bash
$ make stg-core-ping
mysqladmin -h 127.0.0.1 -P 13306 -u core -ppassword ping
mysqld is alive
```

3. terminal_2: Similarly, execute SQL against the forwarded port to verify that arbitrary data can be retrieved.
```bash
$ make stg-core-cmd
mysql -h 127.0.0.1 -P 13306 -u core -ppassword stg_core -e "SELECT * FROM users WHERE id = '01975ff1-5ba9-73ca-be9a-75aa6bb00aaf';\G"
+--------------------------------------+----------+--------------------+---------+--------+---------------------+---------------------+---------------------+
| id                                   | username | email              | role    | status | last_login_at       | created_at          | updated_at          |
+--------------------------------------+----------+--------------------+---------+--------+---------------------+---------------------+---------------------+
| 01975ff1-5ba9-73ca-be9a-75aa6bb00aaf | user01   | user01@example.com | general | active | 2025-06-28 12:27:56 | 2025-06-28 12:27:56 | 2025-06-28 12:27:56 |
+--------------------------------------+----------+--------------------+---------+--------+---------------------+---------------------+---------------------+
```

4. terminal_2: Execute MySQL dump and transfer dump data to the specified directory
```bash
$ make stg-core-dump DUMP_DIR=$(DUMP_DIR)
```

5. terminal_2: Import dump data to local DB
```bash
$ make stg-core-dump-import DUMP_DIR=$(DUMP_DIR)
```
