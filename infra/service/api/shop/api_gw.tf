resource "aws_apigatewayv2_api" "shop_api" {
  name          = "${local.fqn}-api"
  description   = "Shop API"
  protocol_type = "HTTP"

  tags = { Name = "${local.fqn}-api" }
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.shop_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.shop_api.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "shop_api" {
  api_id    = aws_apigatewayv2_api.shop_api.id
  route_key = "ANY /shop/v1/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "shop_api" {
  api_id      = aws_apigatewayv2_api.shop_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_api_mapping" "shop_api" {
  api_id      = aws_apigatewayv2_api.shop_api.id
  domain_name = data.terraform_remote_state.acm.outputs.shop_apigatewayv2_domain_name.id
  stage       = aws_apigatewayv2_stage.shop_api.id
}
