resource "aws_security_group" "bastion" {
  name        = "${local.fqn}-ec2"
  description = "Security group for EC2 instance"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc.id

  tags = { Name = "${local.fqn}-bastion" }
}

# Allow SSH access from anywhere (you may want to restrict this to specific IP ranges)
resource "aws_vpc_security_group_ingress_rule" "bastion_ssh" {
  security_group_id = aws_security_group.bastion.id
  description       = "Allow SSH access"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

# Allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "bastion_all_outbound" {
  security_group_id = aws_security_group.bastion.id
  description       = "Allow all outbound traffic"
  from_port         = -1
  to_port           = -1
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
