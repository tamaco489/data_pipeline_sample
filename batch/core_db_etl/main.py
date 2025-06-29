#!/usr/bin/env python3
"""
Core DB ETL Job
RDS からデータを抽出し、S3 に Parquet 形式で保存する ETL 処理
"""

import sys
# Glue environment only imports - these will be available in AWS Glue runtime
from awsglue.utils import getResolvedOptions  # type: ignore
from pyspark.context import SparkContext  # type: ignore
from awsglue.context import GlueContext  # type: ignore
from awsglue.job import Job  # type: ignore
from awsglue.dynamicframe import DynamicFrame  # type: ignore
from pyspark.sql.functions import current_timestamp, year, month, dayofmonth, col, when  # type: ignore

# 引数の取得
args = getResolvedOptions(sys.argv, [
    'JOB_NAME',
    'output_bucket',
    'database_name',
    'partition_by'
])

# Glue コンテキストの初期化
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# 出力先の設定
output_bucket = args['output_bucket']
database_name = args['database_name']
partition_by = args['partition_by'].split(',')

print(f"Starting ETL job for database: {database_name}")
print(f"Output bucket: {output_bucket}")
print(f"Partition by: {partition_by}")

# 処理対象のテーブルとその設定
TABLES_CONFIG = {
    'users': {
        'partition_column': 'created_at',
        'output_path': 'users'
    },
    'products': {
        'partition_column': 'created_at',
        'output_path': 'products'
    },
    'product_stocks': {
        'partition_column': 'updated_at',
        'output_path': 'product_stocks'
    },
    'product_ratings': {
        'partition_column': 'rated_at',
        'output_path': 'product_ratings'
    },
    'charges': {
        'partition_column': 'charged_at',
        'output_path': 'charges'
    },
    'charge_products': {
        'partition_column': 'created_at',
        'output_path': 'charge_products'
    },
    'reservations': {
        'partition_column': 'reserved_at',
        'output_path': 'reservations'
    },
    'reservation_products': {
        'partition_column': 'created_at',
        'output_path': 'reservation_products'
    }
}

try:
    # 各テーブルに対してETL処理を実行
    for table_name, config in TABLES_CONFIG.items():
        print(f"Processing table: {table_name}")
        
        # Glue Connection を使用してJDBCからデータを読み込み
        dyf = glueContext.create_dynamic_frame.from_options(
            connection_type="mysql",
            connection_options={
                "connectionName": f"{database_name}-glue-connection",
                "dbtable": table_name
            }
        )
        
        # Spark DataFrame に変換
        df = dyf.toDF()
        
        if df.count() > 0:
            # タイムスタンプ列を追加
            df = df.withColumn("etl_timestamp", current_timestamp())
            
            # パーティション列を追加
            partition_column = config['partition_column']
            if partition_column in df.columns:
                df = df.withColumn("year", year(partition_column)) \
                    .withColumn("month", month(partition_column)) \
                    .withColumn("day", dayofmonth(partition_column))
            else:
                # パーティション列がない場合は現在時刻でパーティション
                df = df.withColumn("year", year("etl_timestamp")) \
                    .withColumn("month", month("etl_timestamp")) \
                    .withColumn("day", dayofmonth("etl_timestamp"))
            
            # S3 に Parquet 形式で保存
            output_path = f"s3://{output_bucket}/core_db/{config['output_path']}/"
            
            df.write \
                .mode("append") \
                .partitionBy(partition_by) \
                .parquet(output_path)
            
            print(f"Successfully processed table: {table_name}")
            print(f"Output path: {output_path}")
            print(f"Records processed: {df.count()}")
        else:
            print(f"Table {table_name} is empty, skipping...")
    
    print("ETL job completed successfully!")
    
except Exception as e:
    print(f"Error during ETL job: {str(e)}")
    raise e

finally:
    job.commit()
