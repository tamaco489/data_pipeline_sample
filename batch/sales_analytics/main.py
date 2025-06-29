#!/usr/bin/env python3
"""
Purchase Data ETL Job
購入データを抽出し、S3 に Parquet 形式で保存する ETL 処理
charges と charge_products テーブルを結合して購入データを作成
"""

import sys
# Glue environment only imports - these will be available in AWS Glue runtime
from awsglue.utils import getResolvedOptions  # type: ignore
from pyspark.context import SparkContext  # type: ignore
from awsglue.context import GlueContext  # type: ignore
from awsglue.job import Job  # type: ignore
from awsglue.dynamicframe import DynamicFrame  # type: ignore
from pyspark.sql.functions import current_timestamp, year, month, dayofmonth, col, when, sum as spark_sum  # type: ignore

# 引数の取得
args = getResolvedOptions(sys.argv, [
    'JOB_NAME',
    'output_bucket',
    'database_name',
    'table_name'
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

print(f"Starting Purchase Data ETL job")
print(f"Database: {database_name}")
print(f"Output bucket: {output_bucket}")

try:
    # charges テーブルからデータを読み込み
    print("Loading charges table...")
    charges_dyf = glueContext.create_dynamic_frame.from_options(
        connection_type="mysql",
        connection_options={
            "connectionName": f"{database_name}-glue-connection",
            "dbtable": "charges"
        }
    )
    charges_df = charges_dyf.toDF()
    
    # charge_products テーブルからデータを読み込み
    print("Loading charge_products table...")
    charge_products_dyf = glueContext.create_dynamic_frame.from_options(
        connection_type="mysql",
        connection_options={
            "connectionName": f"{database_name}-glue-connection",
            "dbtable": "charge_products"
        }
    )
    charge_products_df = charge_products_dyf.toDF()
    
    # products テーブルからデータを読み込み（商品情報を取得するため）
    print("Loading products table...")
    products_dyf = glueContext.create_dynamic_frame.from_options(
        connection_type="mysql",
        connection_options={
            "connectionName": f"{database_name}-glue-connection",
            "dbtable": "products"
        }
    )
    products_df = products_dyf.toDF()
    
    if charges_df.count() > 0 and charge_products_df.count() > 0:
        # charges と charge_products を結合
        print("Joining charges and charge_products...")
        purchase_data = charge_products_df.join(
            charges_df,
            charge_products_df.charge_id == charges_df.id,
            "inner"
        ).join(
            products_df,
            charge_products_df.product_id == products_df.id,
            "left"
        )
        
        # 購入データの集計列を追加
        purchase_data = purchase_data.withColumn(
            "total_amount", 
            col("quantity") * col("unit_price")
        ).withColumn(
            "etl_timestamp", 
            current_timestamp()
        )
        
        # 購入日時でパーティション（charged_at または created_at から）
        if "charged_at" in purchase_data.columns:
            purchase_data = purchase_data.withColumn("year", year("charged_at")) \
                                        .withColumn("month", month("charged_at")) \
                                        .withColumn("day", dayofmonth("charged_at"))
        elif "created_at" in purchase_data.columns:
            purchase_data = purchase_data.withColumn("year", year("created_at")) \
                                        .withColumn("month", month("created_at")) \
                                        .withColumn("day", dayofmonth("created_at"))
        else:
            purchase_data = purchase_data.withColumn("year", year("etl_timestamp")) \
                                        .withColumn("month", month("etl_timestamp")) \
                                        .withColumn("day", dayofmonth("etl_timestamp"))
        
        # 選択する列を定義
        selected_columns = [
            "charge_id",
            "user_id", 
            "product_id",
            "product_name",
            "quantity",
            "unit_price",
            "total_amount",
            "amount",  # charges テーブルの合計金額
            "status",
            "charged_at",
            "year",
            "month", 
            "day",
            "etl_timestamp"
        ]
        
        # 必要な列のみを選択
        purchase_data = purchase_data.select([col for col in selected_columns if col in purchase_data.columns])
        
        # S3 に Parquet 形式で保存
        output_path = f"s3://{output_bucket}/purchase_data/"
        
        purchase_data.write \
            .mode("append") \
            .partitionBy("year", "month", "day") \
            .parquet(output_path)
        
        print(f"Successfully processed purchase data")
        print(f"Output path: {output_path}")
        print(f"Total records processed: {purchase_data.count()}")
        
        # 日別売上集計も作成
        print("Creating daily sales summary...")
        daily_sales = purchase_data.groupBy("year", "month", "day") \
                                .agg(
                                    spark_sum("total_amount").alias("daily_total_sales"),
                                    spark_sum("quantity").alias("daily_total_quantity"),
                                    spark_sum("charge_id").alias("daily_order_count")
                                )
        
        daily_sales = daily_sales.withColumn("etl_timestamp", current_timestamp())
        
        # 日別売上集計を保存
        daily_sales_path = f"s3://{output_bucket}/daily_sales_summary/"
        daily_sales.write \
            .mode("append") \
            .partitionBy("year", "month", "day") \
            .parquet(daily_sales_path)
        
        print(f"Daily sales summary saved to: {daily_sales_path}")
        
    else:
        print("No purchase data found, skipping...")
    
    print("Purchase Data ETL job completed successfully!")
    
except Exception as e:
    print(f"Error during Purchase Data ETL job: {str(e)}")
    raise e

finally:
    job.commit()
