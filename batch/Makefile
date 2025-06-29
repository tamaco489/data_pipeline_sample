# =====================================================================================
# Batch Scripts Management
# =====================================================================================

# S3バケット名（環境に応じて変更してください）
S3_BUCKET_NAME ?= stg-data-pipeline-sample-glue-job-script

# デフォルトターゲット
.PHONY: help
help: ## Display available commands
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: upload-all-scripts
upload-all-scripts: ## Upload all ETL scripts to S3
	@echo "🚀 Starting ETL scripts upload to S3..."
	@echo ""
	@echo "📁 Core DB ETL..."
	@$(MAKE) -s -C core_db_etl upload-script
	@echo "📊 Sales Analytics..."
	@$(MAKE) -s -C sales_analytics upload-script
	@echo ""
	@echo "✅ All ETL scripts uploaded successfully!"

.PHONY: delete-all-scripts
delete-all-scripts: ## Delete all ETL scripts from S3
	@echo "🗑️ Starting ETL scripts deletion from S3..."
	@echo ""
	@echo "📁 Core DB ETL..."
	@$(MAKE) -s -C core_db_etl delete-script
	@echo "📊 Sales Analytics..."
	@$(MAKE) -s -C sales_analytics delete-script
	@echo ""
	@echo "✅ All ETL scripts deleted successfully!"

.PHONY: clean-all
clean-all: ## Clean temporary files in all directories
	@echo "🧹 Cleaning all temporary files..."
	$(MAKE) -C core_db_etl clean
	$(MAKE) -C sales_analytics clean
	@echo "All clean operations completed!"

.PHONY: clean
clean: clean-all ## Clean temporary files (alias)

# 個別ディレクトリの操作
.PHONY: core-db-etl
core-db-etl: ## Core DB ETL script operations
	@echo "Core DB ETL operations:"
	@echo "  make -C core_db_etl help"

.PHONY: sales-analytics
sales-analytics: ## Sales Analytics script operations
	@echo "Sales Analytics operations:"
	@echo "  make -C sales_analytics help"
