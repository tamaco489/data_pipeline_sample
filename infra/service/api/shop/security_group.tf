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

# Allow HTTPS traffic from shop_api to secrets_manager_endpoint (egress)
resource "aws_vpc_security_group_egress_rule" "shop_api_to_secrets_manager_endpoint" {
  security_group_id            = aws_security_group.shop_api.id
  description                  = "Allow HTTPS to Secrets Manager endpoint"
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.secrets_manager_endpoint.id
}

# Allow HTTPS traffic from secrets_manager_endpoint to shop_api (ingress)
resource "aws_vpc_security_group_ingress_rule" "secrets_manager_endpoint_from_shop_api" {
  security_group_id            = aws_security_group.secrets_manager_endpoint.id
  description                  = "Allow HTTPS from API"
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.shop_api.id
}
