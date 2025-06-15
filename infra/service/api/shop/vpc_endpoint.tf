# NOTE: VPC endpoint for connecting to Secrets Manager (defined in `service/api/shop/` to avoid circular reference if defined on the Secrets Manager side)
resource "aws_vpc_endpoint" "secrets_manager_endpoint" {
  vpc_id              = data.terraform_remote_state.network.outputs.vpc.id
  service_name        = "com.amazonaws.ap-northeast-1.secretsmanager"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = data.terraform_remote_state.network.outputs.vpc.public_subnet_ids
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.secrets_manager_endpoint.id]

  tags = { Name = "${local.fqn}-secrets-manager-vpc-endpoint" }
}
