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
output "glue_crawler" {
  description = "Glue crawler that crawls Core DB schema"
  value = {
    name = aws_glue_crawler.core_db.name
    arn  = aws_glue_crawler.core_db.arn
  }
}

# TODO: 後続の作業で検証を兼ねて作業を行うため、一旦コメントアウト
# # Glue Jobs
# output "glue_jobs" {
#   description = "Glue ETL jobs"
#   value = {
#     core_db_etl = {
#       name = aws_glue_job.core_db_etl.name
#       arn  = aws_glue_job.core_db_etl.arn
#     }
#     sales_analytics = {
#       name = aws_glue_job.sales_analytics.name
#       arn  = aws_glue_job.sales_analytics.arn
#     }
#   }
# }

# # EventBridge Schedulers
# output "eventbridge_schedulers" {
#   description = "EventBridge schedulers for Glue jobs"
#   value = {
#     core_db_etl = {
#       name = aws_scheduler_schedule.core_db_etl.name
#       arn  = aws_scheduler_schedule.core_db_etl.arn
#     }
#     sales_analytics = {
#       name = aws_scheduler_schedule.sales_analytics.name
#       arn  = aws_scheduler_schedule.sales_analytics.arn
#     }
#   }
# }

# # S3 Bucket References
# output "glue_job_script_bucket" {
#   description = "S3 bucket name for Glue job scripts"
#   value       = data.terraform_remote_state.s3.outputs.glue_job_script.bucket
# }

# output "glue_etl_output_bucket" {
#   description = "S3 bucket name for Glue ETL output"
#   value       = data.terraform_remote_state.s3.outputs.glue_etl_output.bucket
# }
