
# =================================================================
# secrets manager iam policy
# =================================================================
data "aws_iam_policy_document" "bastion_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "bastion" {
  name               = "${local.fqn}-bastion-iam-role"
  assume_role_policy = data.aws_iam_policy_document.bastion_assume_role.json
  tags               = { Name = "${local.fqn}-bastion" }
}

resource "aws_iam_role_policy_attachment" "bastion_execution_role" {
  role       = aws_iam_role.bastion.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}
