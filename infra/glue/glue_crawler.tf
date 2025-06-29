# =====================================================================================
# Glue Crawler
# =====================================================================================
# Glue Crawler を利用して、RDS の Schema を自動で検出・更新し、Glue Data Catalog に反映するための設定
resource "aws_glue_crawler" "core_db" {
  name        = "${local.fqn}-core-db-glue-crawler"
  description = "Glue Crawler for Core DB"
  role        = aws_iam_role.glue_crawler.arn

  # Glue Crawler が検出したテーブルを格納する Glue Data Catalog の DB
  database_name = aws_glue_catalog_database.core_db.name

  # 1時間毎に定期実行 (shema 変更はそこまで頻繁に起こらないので、本番運用時はもう少し間隔を空けるのが better)
  # DOC: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-scheduled-rule-pattern.html#eb-cron-expressions
  schedule = "cron(0 */1 * * ? *)"

  # JDBC 接続経由でターゲットの RDS にアクセスする定義
  jdbc_target {
    connection_name = aws_glue_connection.core_db.name
    path            = "${aws_glue_catalog_database.core_db.name}/%" # NOTE: 本番運用時はワイルドカードを使用しないのが better
  }

  # Schema 変更を検知した場合の挙動を定義
  schema_change_policy {
    # table 削除された場合は Glue Catalog からは削除せず、Log 出力のみとする
    delete_behavior = "LOG"

    # column 追加などの table が更新された場合は Glue Catalog に反映する
    update_behavior = "UPDATE_IN_DATABASE"
  }

  # Schema 変更を検知した場合の詳細な挙動を定義 (Crawler の再実行時に既存テーブル構成が壊れにくいように設計)
  configuration = jsonencode({
    Version = 1.0
    CrawlerOutput = {
      # パーティションの更新はテーブルの設定に従う
      Partitions = { AddOrUpdateBehavior = "InheritFromTable" }

      # テーブルの更新は新しいカラムを追加する
      Tables = { AddOrUpdateBehavior = "MergeNewColumns" }
    }
  })

  tags = { Name = "${local.fqn}-core-db-glue-crawler" }
}
