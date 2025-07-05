# =====================================================================================
# EventBridge Scheduler for Glue Jobs
# =====================================================================================
# メイン ETL ジョブのスケジュール（毎日午前2時に実行）
# resource "aws_scheduler_schedule" "core_db_etl" {
#   name                         = "${local.fqn}-core-db-etl-schedule"
#   description                  = "毎日AM02:00にCore DB ETLを実行"
#   group_name                   = "default"
#   state                        = "ENABLED"
#   schedule_expression          = "cron(0 2 * * ? *)"
#   schedule_expression_timezone = "Asia/Tokyo"

#   flexible_time_window {
#     mode = "OFF"
#   }

#   target {
#     arn      = "arn:aws:glue:${var.region}:${data.aws_caller_identity.current.account_id}:job/${aws_glue_job.core_db_etl.name}"
#     role_arn = aws_iam_role.eventbridge_scheduler.arn
#     retry_policy {
#       maximum_retry_attempts = 0
#     }

#     input = jsonencode({
#       "type" = "core_db_etl"
#     })
#   }
# }

# 売上分析ジョブのスケジュール（1時間毎に実行）
# NOTE: 検証中は5分ごとに実行する
# resource "aws_scheduler_schedule" "sales_analytics" {
#   name                         = "${local.fqn}-sales-analytics-schedule"
#   description                  = "1時間毎に売上分析を実行"
#   group_name                   = "default"
#   state                        = "ENABLED"
#   schedule_expression          = "cron(0 */5 * * ? *)"
#   schedule_expression_timezone = "Asia/Tokyo"

#   flexible_time_window {
#     mode = "OFF"
#   }

#   target {
#     arn      = "arn:aws:glue:${var.region}:${data.aws_caller_identity.current.account_id}:job/${aws_glue_job.sales_analytics.name}"
#     role_arn = aws_iam_role.eventbridge_scheduler.arn
#     retry_policy {
#       maximum_retry_attempts = 0
#     }

#     input = jsonencode({
#       "type" = "sales_analytics"
#     })
#   }
# }
