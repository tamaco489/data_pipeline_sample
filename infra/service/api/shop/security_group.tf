resource "aws_security_group" "shop_api" {
  name        = "${local.fqn}-api"
  description = "Security group for API service running in the VPC"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc.id

  tags = { Name = "${local.fqn}-api" }
}

# Security group for connecting to Secrets Manager VPC endpoint
resource "aws_security_group" "secrets_manager_endpoint" {
  name        = "${local.fqn}-secrets-manager-endpoint"
  description = "Security group for Secrets Manager endpoint"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc.id

  tags = { Name = "${local.fqn}-secrets-manager-endpoint" }
}

# Shop API SG -> Secrets Manager endpoint SG (egress)
resource "aws_vpc_security_group_egress_rule" "shop_api_to_secrets_manager_endpoint" {
  security_group_id            = aws_security_group.shop_api.id
  description                  = "Allow HTTPS to Secrets Manager endpoint SG"
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.secrets_manager_endpoint.id
}

# Lambda Shop API <- secrets_manager_endpoint (ingress)
resource "aws_vpc_security_group_ingress_rule" "secrets_manager_endpoint_from_shop_api" {
  security_group_id            = aws_security_group.secrets_manager_endpoint.id
  description                  = "Allow HTTPS from Shop API SG"
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.shop_api.id
}

# RDS Proxy <- Lambda Shop API
resource "aws_vpc_security_group_ingress_rule" "from_shop_api_to_rds_proxy" {
  security_group_id            = data.terraform_remote_state.rds_core.outputs.rds_proxy_security_group.id
  description                  = "Allow RDS Proxy access from Shop API SG"
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.shop_api.id
  tags                         = { Name = "${local.fqn}-from-shop-api-to-rds-proxy-ingress" }
}
