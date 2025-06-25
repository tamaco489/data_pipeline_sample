# =====================================================================================
# Aurora RDS cluster
# =====================================================================================
resource "aws_security_group" "core_db" {
  name        = "${local.fqn}-core-db"
  description = "Security group for core RDS cluster"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc.id
  tags        = { Name = "${local.fqn}-core-db-sg" }
}

# RDS <- Bastion
resource "aws_vpc_security_group_ingress_rule" "from_bastion_to_core_db" {
  security_group_id            = aws_security_group.core_db.id
  description                  = "Allow MySQL access from Bastion SG"
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  referenced_security_group_id = data.terraform_remote_state.bastion.outputs.bastion_sg.id
  tags                         = { Name = "${local.fqn}-from-bastion-to-core-db-ingress" }
}

# RDS <- RDS Proxy
resource "aws_vpc_security_group_ingress_rule" "from_rds_proxy_to_core_db" {
  security_group_id            = aws_security_group.core_db.id
  description                  = "Allow MySQL access from RDS Proxy SG"
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.rds_proxy.id
  tags                         = { Name = "${local.fqn}-from-rds-proxy-to-core-db-ingress" }
}

# =====================================================================================
# RDS Proxy
# =====================================================================================
resource "aws_security_group" "rds_proxy" {
  name_prefix = "${local.fqn}-rds-proxy-"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc.id
  tags        = { Name = "${local.fqn}-rds-proxy-sg" }
}

# RDS Proxy <- Bastion
resource "aws_vpc_security_group_ingress_rule" "from_bastion_to_rds_proxy" {
  security_group_id            = aws_security_group.rds_proxy.id
  description                  = "Allow MySQL access from Bastion SG"
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  referenced_security_group_id = data.terraform_remote_state.bastion.outputs.bastion_sg.id
  tags                         = { Name = "${local.fqn}-from-bastion-to-rds-proxy-ingress" }
}

# RDS Proxy -> RDS
resource "aws_vpc_security_group_egress_rule" "rds_proxy_to_core_db" {
  security_group_id            = aws_security_group.rds_proxy.id
  description                  = "Allow MySQL access from RDS Proxy SG"
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.core_db.id
  tags                         = { Name = "${local.fqn}-from-rds-proxy-to-core-db-egress" }
}
