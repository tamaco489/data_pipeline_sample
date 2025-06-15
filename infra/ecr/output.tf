output "shop_api" {
  value = {
    arn  = aws_ecr_repository.shop_api.arn
    id   = aws_ecr_repository.shop_api.id
    name = aws_ecr_repository.shop_api.name
    url  = aws_ecr_repository.shop_api.repository_url
  }
}
