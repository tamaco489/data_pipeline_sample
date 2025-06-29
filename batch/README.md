# Batch Scripts

このディレクトリには、データパイプラインで使用するETLスクリプトが含まれています。

## ディレクトリ構成

```
batch/
├── core_db_etl/                    # メインETLスクリプト（全テーブル処理）
│   ├── core_db_etl.py
│   └── Makefile
├── sales_analytics/                # 売上分析データ作成
│   ├── sales_analytics.py
│   └── Makefile
├── Makefile                        # ルートMakefile（全体管理）
└── README.md                       # このファイル
```

## スクリプトの説明

### core_db_etl/
- **目的**: RDSの全テーブルからデータを抽出し、S3にParquet形式で保存
- **処理対象テーブル**: users, products, product_stocks, product_ratings, charges, charge_products, reservations, reservation_products
- **実行頻度**: 毎日午前2時
- **出力先**: `s3://{bucket}/core_db/{table_name}/`

### sales_analytics/
- **目的**: 売上データ（charges + charge_products + products）を結合して分析用データを作成
- **処理内容**: 
  - charges, charge_products, productsテーブルの結合
  - 売上データの詳細情報作成
  - 日別売上集計の自動生成
- **実行頻度**: 1時間毎
- **出力先**: 
  - `s3://{bucket}/purchase_data/` (売上詳細)
  - `s3://{bucket}/daily_sales_summary/` (日別集計)

## 使用方法

### 1. 全体の操作（ルートディレクトリから）

```bash
# 全スクリプトのアップロード
make upload-all-scripts AWS_PROFILE=$(AWS_PROFILE)

# 全ディレクトリの一時ファイルを削除
make clean-all

# ヘルプ表示
make help
```

```bash
# sample
$ make upload-all-scripts AWS_PROFILE=xxxxxxxxxxxx
🚀 Starting ETL scripts upload to S3...

📁 Core DB ETL...
  ✅ Uploaded: main.py → s3://stg-data-pipeline-sample-glue-job-script/scripts/core_db_etl/main.py
📊 Sales Analytics...
  ✅ Uploaded: main.py → s3://stg-data-pipeline-sample-glue-job-script/scripts/sales_analytics/main.py

✅ All ETL scripts uploaded successfully!
```


### 2. 個別スクリプトの操作 (Core DB ETL, Sales Analytics 共通)
```bash
# core_db_etl の場合
cd core_db_etl

# sales_analytics の場合
cd sales_analytics

# スクリプトのみアップロード
make upload-script AWS_PROFILE=$(AWS_PROFILE)

# ヘルプ表示
make help
```

### 3. 個別ディレクトリの操作（ルートから）

```bash
# Core DB ETLの操作
make -C core_db_etl upload-script AWS_PROFILE=$(AWS_PROFILE)

# Sales Analyticsの操作
make -C sales_analytics upload-script AWS_PROFILE=$(AWS_PROFILE)
```

## ディレクトリ分離の利点

### 1. **責任の分離**
- 各スクリプトが独立したディレクトリで管理
- スクリプト固有の設定や依存関係を分離

### 2. **保守性の向上**
- スクリプトごとの変更が他に影響しない
- 個別のアップロードが可能

### 3. **拡張性**
- 新しいETLスクリプトの追加が容易
- 各スクリプトに独自のMakefile設定が可能

## 注意事項

- スクリプトはGlue環境でのみ実行されます。
- ローカル環境でのインポートエラーは正常な動作です。
- スクリプトを修正した場合は、必ず対応するディレクトリで`make upload-script`を実行してください。
- インフラの変更は`infra/glue/`ディレクトリで行ってください。
- このディレクトリはスクリプトのアップロードのみを担当し、Terraformなどのインフラ構成変更は行いません。
