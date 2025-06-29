# =====================================================================================
# Core DB ETL Script Management
# =====================================================================================

# S3バケット名（環境に応じて変更してください）
S3_BUCKET_NAME ?= stg-data-pipeline-sample-glue-job-script

# デフォルトターゲット
.PHONY: help
help: ## Display available commands
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: upload-script
upload-script: ## Upload Core DB ETL script to S3
	@aws s3 cp main.py s3://$(S3_BUCKET_NAME)/scripts/core_db_etl/main.py --quiet
	@echo "  ✅ Uploaded: main.py → s3://$(S3_BUCKET_NAME)/scripts/core_db_etl/main.py"

.PHONY: clean
clean: ## Clean temporary files
	@echo "Cleaning temporary files..."
	find . -name "*.pyc" -delete
	find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
	@echo "Clean completed!"
