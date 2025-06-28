output "rds_proxy_security_group" {
  description = "RDS Proxy security group details."
  value = {
    id          = aws_security_group.rds_proxy.id
    name        = aws_security_group.rds_proxy.name
    name_prefix = aws_security_group.rds_proxy.name_prefix
    vpc_id      = aws_security_group.rds_proxy.vpc_id
    arn         = aws_security_group.rds_proxy.arn
  }
}
