# =====================================================================================
# Glue Data Catalog Database
# =====================================================================================
resource "aws_glue_catalog_database" "core_db" {
  name        = "${local.fqn}-core-db"
  description = "Core database for data pipeline sample"

  parameters = {
    classification     = "parquet"
    has_encrypted_data = "false"
  }
  tags = { Name = "${local.fqn}-core-db" }
}
