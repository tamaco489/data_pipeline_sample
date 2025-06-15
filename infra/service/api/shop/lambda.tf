resource "aws_lambda_function" "shop_api" {
  function_name = "${local.fqn}-api"
  description   = "Shop API"
  role          = aws_iam_role.shop_api.arn
  package_type  = "Image"
  image_uri     = "${data.terraform_remote_state.ecr.outputs.shop_api.url}:shop_api_v0.0.0"
  timeout       = 60
  memory_size   = 128

  vpc_config {
    ipv6_allowed_for_dual_stack = false
    security_group_ids          = [aws_security_group.shop_api.id]
    subnet_ids                  = data.terraform_remote_state.network.outputs.vpc.public_subnet_ids
  }

  lifecycle {
    ignore_changes = [image_uri]
  }

  environment {
    variables = {
      API_SERVICE_NAME = "shop-api"
      API_ENV          = "stg"
      API_PORT         = "8080"
    }
  }

  tags = { Name = "${local.fqn}-api" }
}

resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.shop_api.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.shop_api.execution_arn}/*/*"
}
