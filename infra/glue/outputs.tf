# Glue Catalog Database
output "glue_catalog_database" {
  description = "Glue catalog database for core db"
  value = {
    name = aws_glue_catalog_database.core_db.name
    arn  = aws_glue_catalog_database.core_db.arn
  }
}

# Glue Connection
output "glue_connection" {
  description = "Glue connection for Core DB"
  value = {
    name = aws_glue_connection.core_db.name
    arn  = aws_glue_connection.core_db.arn
  }
}

# Glue Security Group
output "glue_connection_security_group" {
  description = "Security group for Glue connection to Core DB"
  value = {
    id   = aws_security_group.glue_connection.id
    name = aws_security_group.glue_connection.name
  }
}

# Glue Crawler
# output "glue_crawler" {
#   description = "Glue crawler that crawls Core DB schema"
#   value = {
#     name = aws_glue_crawler.core_db.name
#     arn  = aws_glue_crawler.core_db.arn
#   }
# }
