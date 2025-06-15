resource "aws_acm_certificate" "main" {
  domain_name               = "*.${data.terraform_remote_state.route53.outputs.host_zone.name}"
  subject_alternative_names = [data.terraform_remote_state.route53.outputs.host_zone.name]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = { Name = "${var.env}-${var.project}" }
}

# =======================================================
# shop api
# =======================================================
resource "aws_apigatewayv2_domain_name" "shop_api" {
  domain_name = "api.${data.terraform_remote_state.route53.outputs.host_zone.name}"

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.main.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_route53_record" "shop_api" {
  zone_id = data.terraform_remote_state.route53.outputs.host_zone.id
  name    = "api.${data.terraform_remote_state.route53.outputs.host_zone.name}"
  type    = "A"

  alias {
    name                   = aws_apigatewayv2_domain_name.shop_api.domain_name_configuration.0.target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.shop_api.domain_name_configuration.0.hosted_zone_id
    evaluate_target_health = false
  }
}
