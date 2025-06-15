output "acm" {
  value = {
    id   = aws_acm_certificate.main.id
    arn  = aws_acm_certificate.main.arn
    name = aws_acm_certificate.main.domain_name
  }
}

output "shop_apigatewayv2_domain_name" {
  description = "details of the api gateway v2 custom domain name configuration."
  value = {
    id              = aws_apigatewayv2_domain_name.shop_api.id
    domain_name     = aws_apigatewayv2_domain_name.shop_api.domain_name
    endpoint_type   = aws_apigatewayv2_domain_name.shop_api.domain_name_configuration[0].endpoint_type
    security_policy = aws_apigatewayv2_domain_name.shop_api.domain_name_configuration[0].security_policy
    certificate_arn = aws_apigatewayv2_domain_name.shop_api.domain_name_configuration[0].certificate_arn
  }
}
