# =====================================================================================
# RDS Proxy
# =====================================================================================
data "aws_iam_policy_document" "rds_proxy_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "rds_proxy" {
  name               = "${local.fqn}-rds-proxy-role"
  assume_role_policy = data.aws_iam_policy_document.rds_proxy_assume_role.json
  tags               = { Name = "${local.fqn}-rds-proxy" }
}

# =================================================================
# secrets manager iam policy
# =================================================================
data "aws_iam_policy_document" "rds_proxy" {
  statement {
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
    effect = "Allow"
    resources = [
      data.terraform_remote_state.credential_core_db.outputs.core_db.arn,
    ]
  }
}

resource "aws_iam_policy" "rds_proxy" {
  name        = "${local.fqn}-rds-proxy-policy"
  description = "Allows RDS Proxy to access Secrets Manager secrets"
  policy      = data.aws_iam_policy_document.rds_proxy.json
}

resource "aws_iam_role_policy_attachment" "rds_proxy_secrets_manager" {
  role       = aws_iam_role.rds_proxy.name
  policy_arn = aws_iam_policy.rds_proxy.arn
}
