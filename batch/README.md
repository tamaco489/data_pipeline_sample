# Batch Scripts

This directory contains ETL scripts used in the data pipeline.

## Directory Structure

```
batch/
├── core_db_etl/                    # Main ETL script (all tables processing)
│   ├── core_db_etl.py
│   └── Makefile
├── sales_analytics/                # Sales analytics data creation
│   ├── sales_analytics.py
│   └── Makefile
├── Makefile                        # Root Makefile (overall management)
└── README.md                       # This file
```

## Script Descriptions

### core_db_etl/
- **Purpose**: Extract data from all RDS tables and save to S3 in Parquet format
- **Target Tables**: users, products, product_stocks, product_ratings, charges, charge_products, reservations, reservation_products
- **Execution Frequency**: Daily at 2:00 AM
- **Output Destination**: `s3://{bucket}/core_db/{table_name}/`

### sales_analytics/
- **Purpose**: Create analytics data by combining sales data (charges + charge_products + products)
- **Processing Content**: 
  - Join charges, charge_products, and products tables
  - Create detailed sales data information
  - Automatically generate daily sales summaries
- **Execution Frequency**: Every hour
- **Output Destinations**: 
  - `s3://{bucket}/purchase_data/` (sales details)
  - `s3://{bucket}/daily_sales_summary/` (daily summaries)

## Usage

### 1. Overall Operations (from root directory)

```bash
cd batch/

# Upload all scripts
make upload-all-scripts AWS_PROFILE=$(AWS_PROFILE)

# Clean temporary files from all directories
make clean-all

# Display help
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


### 2. Individual Script Operations (Common for Core DB ETL, Sales Analytics)
```bash
# For core_db_etl
cd core_db_etl

# For sales_analytics
cd sales_analytics

# Upload script only
make upload-script AWS_PROFILE=$(AWS_PROFILE)

# Display help
make help
```

### 3. Individual Directory Operations (from root)

```bash
# Core DB ETL operations
make -C core_db_etl upload-script AWS_PROFILE=$(AWS_PROFILE)

# Sales Analytics operations
make -C sales_analytics upload-script AWS_PROFILE=$(AWS_PROFILE)
```

## Benefits of Directory Separation

### 1. **Separation of Responsibilities**
- Each script is managed in an independent directory
- Script-specific settings and dependencies are isolated

### 2. **Improved Maintainability**
- Changes to individual scripts don't affect others
- Individual uploads are possible

### 3. **Scalability**
- Easy to add new ETL scripts
- Each script can have its own Makefile configuration

## Important Notes

- Scripts are executed only in the Glue environment.
- Import errors in the local environment are normal behavior.
- When modifying scripts, always run `make upload-script` in the corresponding directory.
- Infrastructure changes should be made in the `infra/glue/` directory.
- This directory is responsible only for script uploads and does not perform infrastructure configuration changes such as Terraform.
