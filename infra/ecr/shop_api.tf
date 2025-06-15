resource "aws_ecr_repository" "shop_api" {
  name                 = local.shop_api
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = { Name = "${local.shop_api}" }
}

resource "aws_ecr_lifecycle_policy" "shop_api" {
  repository = aws_ecr_repository.shop_api.name
  policy = jsonencode(
    {
      "rules" : [
        {
          "rulePriority" : 1,
          "description" : "バージョン付きのイメージを5個保持する、6個目がアップロードされた際には古いものから順に削除されていく",
          "selection" : {
            "tagStatus" : "tagged",
            "tagPrefixList" : ["shop_api_v"],
            "countType" : "imageCountMoreThan",
            "countNumber" : 5
          },
          "action" : {
            "type" : "expire"
          }
        },
        {
          "rulePriority" : 2,
          "description" : "stgタグ付きの最新イメージのみを保持する",
          "selection" : {
            "tagStatus" : "tagged",
            "tagPrefixList" : ["stg"], // stgタグ付きイメージ
            "countType" : "imageCountMoreThan",
            "countNumber" : 1, // 最新世代を保持
          },
          "action" : {
            "type" : "expire"
          }
        },
        {
          "rulePriority" : 3,
          "description" : "タグが設定されていないイメージをアップロードされてから3日後に削除する",
          "selection" : {
            "tagStatus" : "untagged",
            "countType" : "sinceImagePushed",
            "countUnit" : "days",
            "countNumber" : 3
          },
          "action" : {
            "type" : "expire"
          }
        },
        {
          "rulePriority" : 4,
          "description" : "タグが設定されたイメージをアップロードされてから7日後に削除する",
          "selection" : {
            "tagStatus" : "any",
            "countType" : "sinceImagePushed",
            "countUnit" : "days",
            "countNumber" : 7
          },
          "action" : {
            "type" : "expire"
          }
        }
      ]
    }
  )
}
