resource "aws_route53_zone" "main" {
  name    = var.domain
  comment = "売上計上システムの検証で利用"
  tags    = { Name = "${var.env}-${var.project}" }
}
