resource "aws_instance" "bastion" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = data.terraform_remote_state.network.outputs.vpc.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.bastion.id]
  iam_instance_profile   = aws_iam_instance_profile.bastion.name

  tags = { Name = "${local.fqn}-bastion" }

  user_data = <<-EOF
    #cloud-config
    disable_root: 1
    ssh_pwauth: 0
    repo_upgrade: minimal
    runcmd:
      # MySQL install
      - sudo dnf -y install https://dev.mysql.com/get/mysql84-community-release-el9-1.noarch.rpm
      - sudo dnf -y install mysql mysql-community-client mysql-community-server

      # Git install
      - sudo dnf install -y git

      # Go 1.24.2 install
      - curl -LO https://go.dev/dl/go1.24.2.linux-amd64.tar.gz
      - sudo rm -rf /usr/local/go
      - sudo tar -C /usr/local -xzf go1.24.2.linux-amd64.tar.gz

      # Setup workspace
      - mkdir -p /home/ssm-user/workspace
      - git clone https://github.com/tamaco489/data_pipeline_sample.git /home/ssm-user/workspace/data_pipeline_sample
  EOF
}

resource "aws_iam_instance_profile" "bastion" {
  name = "${local.fqn}-bastion-iam-instance-profile"
  role = aws_iam_role.bastion.name
  tags = { Name = "${local.fqn}-bastion" }
}
