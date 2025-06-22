output "bastion_sg" {
  value = {
    id          = aws_security_group.bastion.id
    arn         = aws_security_group.bastion.arn
    name        = aws_security_group.bastion.name
    description = aws_security_group.bastion.description
  }
}
