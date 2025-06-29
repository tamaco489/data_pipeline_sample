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

# # =====================================================================================
# # Glue Job for Sales Analytics
# # =====================================================================================
# # 売上分析データ作成用の ETL ジョブ
# resource "aws_glue_job" "sales_analytics" {
#   name         = "${local.fqn}-sales-analytics-job"
#   description  = "ETL job to create sales analytics data from Core DB and save to S3"
#   role_arn     = aws_iam_role.glue_job.arn

#   glue_version = "4.0"

#   max_retries = 0
#   timeout     = 2880

#   number_of_workers = 2
#   worker_type       = "G.1X"

#   command {
#     name            = "glueetl"
#     script_location = "s3://${data.terraform_remote_state.s3.outputs.glue_job_script.bucket}/scripts/sales_analytics/main.py"
#     python_version  = "3"
#   }

#   default_arguments = {
#     "--output_bucket" = data.terraform_remote_state.s3.outputs.glue_etl_output.bucket
#     "--database_name" = aws_glue_catalog_database.core_db.name

#     "--enable-continuous-cloudwatch-log" = "true"
#     "--enable-metrics"                   = "true"
#     "--job-bookmark-option"              = "job-bookmark-enable"
#     "--partition_by"                     = "year,month,day"
#   }

#   tags = { Name = "${local.fqn}-sales-analytics-job" }
# }

# # =====================================================================================
# # EventBridge Scheduler for Glue Jobs
# # =====================================================================================
# # Glue Job の定期実行を管理する EventBridge Scheduler

# # メイン ETL ジョブのスケジュール（毎日午前2時に実行）
# resource "aws_scheduler_schedule" "core_db_etl" {
#   name       = "${local.fqn}-core-db-etl-schedule"
#   group_name = "default"

#   flexible_time_window {
#     mode = "OFF"
#   }

#   schedule_expression = "cron(0 2 * * ? *)"

#   target {
#     arn      = "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:job/${aws_glue_job.core_db_etl.name}"
#     role_arn = aws_iam_role.eventbridge_scheduler.arn
#   }
# }

# # 売上分析ジョブのスケジュール（1時間毎に実行）
# resource "aws_scheduler_schedule" "sales_analytics" {
#   name       = "${local.fqn}-sales-analytics-schedule"
#   group_name = "default"

#   flexible_time_window {
#     mode = "OFF"
#   }

#   schedule_expression = "cron(0 */1 * * ? *)"

#   target {
#     arn      = "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:job/${aws_glue_job.sales_analytics.name}"
#     role_arn = aws_iam_role.eventbridge_scheduler.arn
#   }
# }
