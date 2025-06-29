# =====================================================================================
# Glue Data Catalog Database
# =====================================================================================
resource "aws_glue_catalog_database" "analytics_db" {
  name        = "${local.fqn}-analytics-db"
  description = "Analytics database for data pipeline sample"

  parameters = {
    classification     = "parquet"
    has_encrypted_data = "false"
  }
  tags = { Name = "${local.fqn}-analytics-db" }
}
