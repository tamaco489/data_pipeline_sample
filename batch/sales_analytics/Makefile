# =====================================================================================
# Sales Analytics Script Management
# =====================================================================================
S3_BUCKET_NAME ?= stg-data-pipeline-sample-glue-job-script

.PHONY: help
help: ## Display available commands
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: upload-script delete-script clean
upload-script: ## Upload Sales Analytics script to S3
	@aws s3 cp main.py s3://$(S3_BUCKET_NAME)/scripts/sales_analytics/main.py --quiet
	@echo "  ✅ Uploaded: main.py → s3://$(S3_BUCKET_NAME)/scripts/sales_analytics/main.py"

delete-script: ## Delete Sales Analytics script from S3
	@aws s3 rm s3://$(S3_BUCKET_NAME)/scripts/sales_analytics/main.py --quiet
	@echo "  ✅ Deleted: s3://$(S3_BUCKET_NAME)/scripts/sales_analytics/main.py"

clean: ## Clean temporary files
	@echo "Cleaning temporary files..."
	find . -name "*.pyc" -delete
	find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
	@echo "Clean completed!"
