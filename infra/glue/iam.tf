# =================================================================
# glue crawler iam policy
# =================================================================
# Glue Crawler IAM Role
data "aws_iam_policy_document" "glue_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "glue_service" {
  name               = "${local.fqn}-glue-service-role"
  assume_role_policy = data.aws_iam_policy_document.glue_assume_role.json
  tags               = { Name = "${local.fqn}-glue-service" }
}

# Glue Service Role Policy
# DOC: https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AWSGlueServiceRole.html
# NOTE: Glue Crawler が Glue, S3 のリソースを扱うためのロールをアタッチする
resource "aws_iam_role_policy_attachment" "glue_service_role" {
  role       = aws_iam_role.glue_service.name
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
  role       = aws_iam_role.glue_service.name
  policy_arn = aws_iam_policy.glue_secrets_manager.arn
}

# =================================================================
# S3 access policy for Glue Service
# =================================================================
# Glue Service 用の S3 アクセスポリシー
data "aws_iam_policy_document" "glue_s3_access" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket"
    ]
    resources = [
      data.terraform_remote_state.s3.outputs.glue_etl_output.arn,
      "${data.terraform_remote_state.s3.outputs.glue_etl_output.arn}/*",
      data.terraform_remote_state.s3.outputs.glue_job_script.arn,
      "${data.terraform_remote_state.s3.outputs.glue_job_script.arn}/*",
      data.terraform_remote_state.s3.outputs.athena_query_result.arn,
      "${data.terraform_remote_state.s3.outputs.athena_query_result.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "glue_s3_access" {
  name        = "${local.fqn}-glue-s3-access-policy"
  description = "Allows Glue to access S3 buckets for ETL operations"
  policy      = data.aws_iam_policy_document.glue_s3_access.json
}

resource "aws_iam_role_policy_attachment" "glue_s3_access" {
  role       = aws_iam_role.glue_service.name
  policy_arn = aws_iam_policy.glue_s3_access.arn
}
