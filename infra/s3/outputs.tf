output "glue_etl_output" {
  description = "s3 bucket for glue ETL output"
  value = {
    id   = aws_s3_bucket.glue_etl_output.id
    arn  = aws_s3_bucket.glue_etl_output.arn
    name = aws_s3_bucket.glue_etl_output.bucket
  }
}

output "athena_query_result" {
  description = "s3 bucket for athena query results"
  value = {
    id   = aws_s3_bucket.athena_query_result.id
    arn  = aws_s3_bucket.athena_query_result.arn
    name = aws_s3_bucket.athena_query_result.bucket
  }
}

output "glue_job_script" {
  description = "s3 bucket for glue job scripts and assets"
  value = {
    id   = aws_s3_bucket.glue_job_script.id
    arn  = aws_s3_bucket.glue_job_script.arn
    name = aws_s3_bucket.glue_job_script.bucket
  }
}
