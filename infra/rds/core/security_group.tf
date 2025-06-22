resource "aws_security_group" "core_db" {
  name        = "${local.fqn}-core-db"
  description = "Security group for core RDS cluster"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc.id

  tags = { Name = "${local.fqn}-core-db" }
}

resource "aws_vpc_security_group_ingress_rule" "from_bastion" {
  security_group_id            = aws_security_group.core_db.id
  description                  = "Allow MySQL access from Bastion SG"
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  referenced_security_group_id = data.terraform_remote_state.bastion.outputs.bastion_sg.id
}
