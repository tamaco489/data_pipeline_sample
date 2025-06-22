resource "aws_db_proxy" "core" {
  name                   = "${local.fqn}-core-db-proxy"
  engine_family          = "MYSQL"
  idle_client_timeout    = 60
  debug_logging          = false
  role_arn               = aws_iam_role.rds_proxy.arn
  vpc_security_group_ids = [aws_security_group.rds_proxy.id]
  vpc_subnet_ids         = data.terraform_remote_state.network.outputs.vpc.public_subnet_ids
  # vpc_subnet_ids         = data.terraform_remote_state.network.outputs.vpc.private_subnet_ids # 本番運用中は private subnet にするのが better

  auth {
    auth_scheme = "SECRETS"
    iam_auth    = "DISABLED"
    secret_arn  = data.terraform_remote_state.credential_core_db.outputs.core_db.arn
  }

  lifecycle {
    prevent_destroy = false # 本番運用中は true にしておくのが better
  }

  tags = { Name = "${local.fqn}-core-db-proxy" }
}

resource "aws_db_proxy_default_target_group" "core" {
  db_proxy_name = aws_db_proxy.core.name

  connection_pool_config {
    connection_borrow_timeout    = 120
    max_connections_percent      = 90
    max_idle_connections_percent = 45

    # DOC: https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_ConnectionPoolConfigurationInfo.html
    session_pinning_filters = []
  }

  lifecycle {
    prevent_destroy = false # 本番運用中は true にしておくのが better
  }
}

resource "aws_db_proxy_target" "core" {
  db_cluster_identifier = aws_rds_cluster.core_db.id
  db_proxy_name         = aws_db_proxy.core.name
  target_group_name     = aws_db_proxy_default_target_group.core.name

  lifecycle {
    prevent_destroy = false # 本番運用中は true にしておくのが better
  }
}
