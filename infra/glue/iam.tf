# =================================================================
# basic iam policy
# =================================================================
# Glue Crawler IAM Role
data "aws_iam_policy_document" "glue_crawler_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "glue_crawler" {
  name               = "${local.fqn}-glue-crawler-role"
  assume_role_policy = data.aws_iam_policy_document.glue_crawler_assume_role.json
  tags               = { Name = "${local.fqn}-glue-crawler" }
}

# Glue Service Role Policy
# DOC: https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AWSGlueServiceRole.html
# NOTE: Glue Crawler が Glue, S3 のリソースを扱うためのロールをアタッチする
resource "aws_iam_role_policy_attachment" "glue_service_role" {
  role       = aws_iam_role.glue_crawler.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

# =================================================================
# secrets manager iam policy
# =================================================================
# Secrets Manager Access Policy
data "aws_iam_policy_document" "glue_secrets_manager" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
    ]
    resources = [data.terraform_remote_state.credential_core_db.outputs.core_db.arn]
  }
}

resource "aws_iam_policy" "glue_secrets_manager" {
  name        = "${local.fqn}-glue-secrets-manager-policy"
  description = "Allows Glue to access Secrets Manager secrets"
  policy      = data.aws_iam_policy_document.glue_secrets_manager.json
}

resource "aws_iam_role_policy_attachment" "glue_secrets_manager" {
  role       = aws_iam_role.glue_crawler.name
  policy_arn = aws_iam_policy.glue_secrets_manager.arn
}

# TODO: 後続の作業で検証を兼ねて作業を行うため、一旦コメントアウト
# =================================================================
# Glue Job IAM Role
# =================================================================
# Glue Job 用の IAM ロール
# resource "aws_iam_role" "glue_job" {
#   name               = "${local.fqn}-glue-job-role"
#   assume_role_policy = data.aws_iam_policy_document.glue_crawler_assume_role.json
#   tags               = { Name = "${local.fqn}-glue-job" }
# }

# Glue Job 用のサービスロールポリシー
# resource "aws_iam_role_policy_attachment" "glue_job_service_role" {
#   role       = aws_iam_role.glue_job.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
# }

# Glue Job 用の Secrets Manager アクセスポリシー
# resource "aws_iam_role_policy_attachment" "glue_job_secrets_manager" {
#   role       = aws_iam_role.glue_job.name
#   policy_arn = aws_iam_policy.glue_secrets_manager.arn
# }

# =================================================================
# EventBridge Scheduler IAM Role
# =================================================================
# EventBridge Scheduler 用の IAM ロール
# data "aws_iam_policy_document" "eventbridge_scheduler_assume_role" {
#   statement {
#     effect = "Allow"
#     principals {
#       type        = "Service"
#       identifiers = ["scheduler.amazonaws.com"]
#     }
#     actions = ["sts:AssumeRole"]
#   }
# }

# resource "aws_iam_role" "eventbridge_scheduler" {
#   name               = "${local.fqn}-eventbridge-scheduler-role"
#   assume_role_policy = data.aws_iam_policy_document.eventbridge_scheduler_assume_role.json
#   tags               = { Name = "${local.fqn}-eventbridge-scheduler" }
# }

# EventBridge Scheduler 用のポリシー
# data "aws_iam_policy_document" "eventbridge_scheduler_policy" {
#   statement {
#     effect = "Allow"
#     actions = [
#       "glue:StartJobRun",
#       "glue:GetJobRun",
#       "glue:GetJobRuns",
#       "glue:BatchStopJobRun"
#     ]
#     resources = [
#       aws_glue_job.core_db_etl.arn,
#       aws_glue_job.sales_analytics.arn
#     ]
#   }
# }

# resource "aws_iam_policy" "eventbridge_scheduler" {
#   name        = "${local.fqn}-eventbridge-scheduler-policy"
#   description = "Allows EventBridge Scheduler to start Glue jobs"
#   policy      = data.aws_iam_policy_document.eventbridge_scheduler_policy.json
# }

# resource "aws_iam_role_policy_attachment" "eventbridge_scheduler" {
#   role       = aws_iam_role.eventbridge_scheduler.name
#   policy_arn = aws_iam_policy.eventbridge_scheduler.arn
# }
