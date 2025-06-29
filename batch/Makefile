# =====================================================================================
# Batch Scripts Management
# =====================================================================================
S3_BUCKET_NAME ?= stg-data-pipeline-sample-glue-job-script

.PHONY: help
help: ## Display available commands
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: upload-all-scripts delete-all-scripts clean-all
upload-all-scripts: ## Upload all ETL scripts to S3
	@echo "🚀 Starting ETL scripts upload to S3..."
	@echo ""
	@echo "📁 Core DB ETL..."
	@$(MAKE) -s -C core_db_etl upload-script
	@echo "📊 Sales Analytics..."
	@$(MAKE) -s -C sales_analytics upload-script
	@echo ""
	@echo "✅ All ETL scripts uploaded successfully!"

delete-all-scripts: ## Delete all ETL scripts from S3
	@echo "🗑️ Starting ETL scripts deletion from S3..."
	@echo ""
	@echo "📁 Core DB ETL..."
	@$(MAKE) -s -C core_db_etl delete-script
	@echo "📊 Sales Analytics..."
	@$(MAKE) -s -C sales_analytics delete-script
	@echo ""
	@echo "✅ All ETL scripts deleted successfully!"

clean-all: ## Clean temporary files in all directories
	@echo "🧹 Cleaning all temporary files..."
	$(MAKE) -C core_db_etl clean
	$(MAKE) -C sales_analytics clean
	@echo "All clean operations completed!"

clean: clean-all ## Clean temporary files (alias)

# Individual directory operations
.PHONY: core-db-etl sales-analytics
core-db-etl: ## Core DB ETL script operations
	@echo "Core DB ETL operations:"
	@echo "  make -C core_db_etl help"

sales-analytics: ## Sales Analytics script operations
	@echo "Sales Analytics operations:"
	@echo "  make -C sales_analytics help"
