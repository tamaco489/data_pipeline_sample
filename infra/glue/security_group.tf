# =====================================================================================
# Glue Security Group
# =====================================================================================
resource "aws_security_group" "glue_connection" {
  name        = "${local.fqn}-glue-connection"
  description = "Security group for Glue connection to RDS"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc.id

  tags = { Name = "${local.fqn}-glue-connection" }
}

# Glue Connection -> RDS Proxy
resource "aws_vpc_security_group_egress_rule" "glue_to_rds_proxy" {
  security_group_id            = aws_security_group.glue_connection.id
  description                  = "Allow MySQL access to RDS Proxy from Glue"
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  referenced_security_group_id = data.terraform_remote_state.rds_core.outputs.rds_proxy_security_group.id
  tags                         = { Name = "${local.fqn}-glue-to-rds-proxy-egress" }
}

# RDS Proxy <- Glue Connection
resource "aws_vpc_security_group_ingress_rule" "rds_proxy_from_glue" {
  security_group_id            = data.terraform_remote_state.rds_core.outputs.rds_proxy_security_group.id
  description                  = "Allow MySQL access from Glue Connection SG"
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.glue_connection.id
  tags                         = { Name = "${local.fqn}-rds-proxy-from-glue-ingress" }
}
