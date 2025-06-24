resource "aws_db_subnet_group" "core_db" {
  name = "${local.fqn}-core-db-subnet-group"

  # NOTE: Using public subnets for verification purposes
  subnet_ids = data.terraform_remote_state.network.outputs.vpc.public_subnet_ids
  # subnet_ids = data.terraform_remote_state.network.outputs.vpc.private_subnet_ids

  tags = { Name = "${local.fqn}-core-db-subnet-group" }
}

resource "aws_rds_cluster" "core_db" {
  cluster_identifier = "${local.fqn}-core-db"
  engine             = "aurora-mysql"
  engine_version     = "8.0.mysql_aurora.3.08.2"
  engine_mode        = "provisioned" # cluster側は provisioned 扱いになる
  database_name      = "stg_core"
  master_username    = "core"
  master_password    = "password"
  port               = 3306

  serverlessv2_scaling_configuration {
    min_capacity = 0.5
    max_capacity = 2
  }

  storage_encrypted               = true
  backup_retention_period         = 0
  preferred_backup_window         = "00:00-01:00"
  preferred_maintenance_window    = "sun:05:00-sun:06:00"
  db_subnet_group_name            = aws_db_subnet_group.core_db.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.core_db.name
  skip_final_snapshot             = true
  deletion_protection             = false
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  vpc_security_group_ids          = [aws_security_group.core_db.id]

  lifecycle {
    ignore_changes  = [master_password] # password は terraform 管理外
    prevent_destroy = false             # 本番運用中は true にしておくのが better
  }
}

resource "aws_rds_cluster_instance" "core_db_instance" {
  identifier                   = "${local.fqn}-core-db-instance-1"
  cluster_identifier           = aws_rds_cluster.core_db.id
  instance_class               = "db.serverless"
  engine                       = aws_rds_cluster.core_db.engine
  engine_version               = aws_rds_cluster.core_db.engine_version
  auto_minor_version_upgrade   = false
  publicly_accessible          = false
  performance_insights_enabled = false
}
