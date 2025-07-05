# TODO: 後続の作業で検証を兼ねて作業を行うため、一旦コメントアウト
# =====================================================================================
# Glue Job for ETL Processing
# =====================================================================================
# RDS からデータを抽出し、S3 に Parquet 形式で保存する ETL 処理
# resource "aws_glue_job" "core_db_etl" {
#   name         = "${local.fqn}-core-db-etl-job"
#   description  = "ETL job to extract data from Core DB and save to S3"
#   role_arn     = aws_iam_role.glue_job.arn

#   # Glue Job の実行環境設定
#   glue_version = "4.0"

#   # 実行時の設定
#   max_retries = 0
#   timeout     = 2880 # 48時間 (最大値)

#   # ワーカー設定
#   number_of_workers = 2
#   worker_type       = "G.1X"

#   # スクリプトの場所 (S3 にアップロードした Python スクリプト)
#   command {
#     name            = "glueetl"
#     script_location = "s3://${data.terraform_remote_state.s3.outputs.glue_job_script.bucket}/scripts/core_db_etl/main.py"
#     python_version  = "3"
#   }

#   # デフォルト引数
#   default_arguments = {
#     # 出力先の S3 バケット
#     "--output_bucket" = data.terraform_remote_state.s3.outputs.glue_etl_output.bucket

#     # データベース名
#     "--database_name" = aws_glue_catalog_database.core_db.name

#     # ログレベル
#     "--enable-continuous-cloudwatch-log" = "true"
#     "--enable-metrics"                   = "true"

#     # ジョブブックマーク（重複処理を防ぐ）
#     "--job-bookmark-option" = "job-bookmark-enable"

#     # パーティション設定
#     "--partition_by" = "year,month,day"
#   }

#   tags = { Name = "${local.fqn}-core-db-etl-job" }
# }

# =====================================================================================
# Glue Job for Sales Analytics
# =====================================================================================
# 売上分析データ作成用の ETL ジョブ
resource "aws_glue_job" "sales_analytics" {
  name              = "${local.fqn}-sales-analytics-job"
  description       = "ETL job to create sales analytics data from Core DB and save to S3"
  role_arn          = aws_iam_role.glue_service.arn
  glue_version      = "4.0"
  max_retries       = 0
  timeout           = 60
  number_of_workers = 2
  worker_type       = "G.1X"

  connections = [aws_glue_connection.core_db.name]

  command {
    name            = "glueetl"
    script_location = "s3://${data.terraform_remote_state.s3.outputs.glue_job_script.name}/scripts/sales_analytics/main.py"
    python_version  = "3"
  }

  execution_property {
    max_concurrent_runs = 1
  }

  default_arguments = {
    "--output_bucket" = data.terraform_remote_state.s3.outputs.glue_etl_output.name
    "--database_name" = aws_glue_catalog_database.core_db.name

    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-metrics"                   = "true"
    "--job-bookmark-option"              = "job-bookmark-enable"
    "--partition_by"                     = "year,month,day"
    "--conf"                             = "spark.hadoop.aws.glue.proxy.host=169.254.76.0 spark.hadoop.aws.glue.proxy.port=8888 spark.glue.USE_PROXY=true"
  }

  tags = { Name = "${local.fqn}-sales-analytics-job" }
}
