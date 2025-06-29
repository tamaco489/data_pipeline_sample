# =====================================================================================
# S3 bucket for extracted data from Glue ETL
# =====================================================================================
# Glue Job で ETL されたデータの保存先
# 主な用途:
# - AWS Glue Jobの出力先: RDSなどのソースから抽出・変換したデータ (CSV, Parquetなど) を保存するためのバケット
# - Athenaのクエリ対象データとして利用: Athena で SELECT する対象はこのバケットにある Parquet などのファイルが該当
resource "aws_s3_bucket" "glue_etl_output" {
  bucket = "${local.fqn}-glue-etl-output"

  tags = { Name = "${local.fqn}-glue-etl-output" }
}

resource "aws_s3_bucket_versioning" "glue_etl_output_versioning" {
  bucket = aws_s3_bucket.glue_etl_output.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "glue_etl_output_public_access_block" {
  bucket = aws_s3_bucket.glue_etl_output.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "glue_etl_output_encryption" {
  bucket = aws_s3_bucket.glue_etl_output.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


# =====================================================================================
# S3 bucket for Athena query results
# =====================================================================================
# Athena SQL実行結果の保存先
# 主な用途:
# - Athena はクエリを実行後、必ず S3 に結果を CSV 形式で出力するため、その結果を保存するためのバケット
# - Lambda 処理で集計結果をここに保存し、後続の BI ツールなどが参照できるようにする
resource "aws_s3_bucket" "athena_query_result" {
  bucket = "${local.fqn}-athena-query-results"

  tags = { Name = "${local.fqn}-athena-query-results" }
}

resource "aws_s3_bucket_versioning" "athena_query_result_versioning" {
  bucket = aws_s3_bucket.athena_query_result.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "athena_query_result_public_access_block" {
  bucket = aws_s3_bucket.athena_query_result.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "athena_query_result_encryption" {
  bucket = aws_s3_bucket.athena_query_result.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


# =====================================================================================
# S3 bucket for Glue scripts and logs
# =====================================================================================
# Glue Job のスクリプト、及びログの保存先
# 主な用途：
# - Glue Job の Python Script を保存するためのバケット
# - Glue Job の script_location に指定する .py ファイルをこのバケットにアップロードする
resource "aws_s3_bucket" "glue_job_script" {
  bucket = "${local.fqn}-glue-job-script"

  tags = { Name = "${local.fqn}-glue-job-script" }
}

resource "aws_s3_bucket_versioning" "glue_job_script_versioning" {
  bucket = aws_s3_bucket.glue_job_script.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "glue_job_script_public_access_block" {
  bucket = aws_s3_bucket.glue_job_script.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "glue_job_script_encryption" {
  bucket = aws_s3_bucket.glue_job_script.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
