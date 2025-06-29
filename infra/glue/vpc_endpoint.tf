# =====================================================================================
# VPC Endpoints for Glue Connection
# =====================================================================================
# VPC Endpoint for Glue Connection to access S3
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = data.terraform_remote_state.network.outputs.vpc.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [for rt in data.aws_route_tables.network.ids : rt]

  tags = { Name = "${local.fqn}-s3-vpc-endpoint" }
}

# VPC Endpoint for Glue Connection to access Glue
resource "aws_vpc_endpoint" "glue" {
  vpc_id              = data.terraform_remote_state.network.outputs.vpc.id
  service_name        = "com.amazonaws.${var.region}.glue"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = data.terraform_remote_state.network.outputs.vpc.public_subnet_ids
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.vpc_endpoint.id]

  tags = { Name = "${local.fqn}-glue-vpc-endpoint" }
}

# VPC Endpoint for Glue Connection to access Secrets Manager
resource "aws_vpc_endpoint" "secrets_manager" {
  vpc_id              = data.terraform_remote_state.network.outputs.vpc.id
  service_name        = "com.amazonaws.${var.region}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = data.terraform_remote_state.network.outputs.vpc.public_subnet_ids
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.vpc_endpoint.id]

  tags = { Name = "${local.fqn}-secrets-manager-vpc-endpoint" }
}

# Security Group for VPC Endpoints
resource "aws_security_group" "vpc_endpoint" {
  name        = "${local.fqn}-vpc-endpoint"
  description = "Security group for VPC endpoints"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc.id

  tags = { Name = "${local.fqn}-vpc-endpoint" }
}

# VPC Endpoint -> Glue Connection (HTTPS)
resource "aws_vpc_security_group_egress_rule" "glue_to_vpc_endpoint" {
  security_group_id            = aws_security_group.glue_connection.id
  description                  = "Allow HTTPS access to VPC endpoints from Glue"
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.vpc_endpoint.id
  tags                         = { Name = "${local.fqn}-glue-to-vpc-endpoint-egress" }
}

# Glue Connection -> VPC Endpoint (HTTPS)
resource "aws_vpc_security_group_ingress_rule" "vpc_endpoint_from_glue" {
  security_group_id            = aws_security_group.vpc_endpoint.id
  description                  = "Allow HTTPS access from Glue Connection SG"
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.glue_connection.id
  tags                         = { Name = "${local.fqn}-vpc-endpoint-from-glue-ingress" }
}
