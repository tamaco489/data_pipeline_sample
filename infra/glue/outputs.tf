# Glue Catalog Database
output "glue_catalog_database" {
  description = "Glue catalog database for analytics"
  value = {
    name = aws_glue_catalog_database.analytics_db.name
    arn  = aws_glue_catalog_database.analytics_db.arn
  }
}

# Glue Connection
# output "glue_connection" {
#   description = "Glue connection for RDS"
#   value = {
#     name = aws_glue_connection.rds_connection.name
#     arn  = aws_glue_connection.rds_connection.arn
#   }
# }

# Glue Crawler
# output "glue_crawler" {
#   description = "Glue crawler that crawls RDS schema"
#   value = {
#     name = aws_glue_crawler.rds_crawler.name
#     arn  = aws_glue_crawler.rds_crawler.arn
#   }
# }

# Glue用の Security Group
# output "glue_connection_security_group" {
#   description = "Security group for Glue connection to RDS"
#   value = {
#     id   = aws_security_group.glue_connection.id
#     name = aws_security_group.glue_connection.name
#   }
# }
