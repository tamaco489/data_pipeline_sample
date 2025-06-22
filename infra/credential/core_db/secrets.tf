resource "aws_secretsmanager_secret" "core_db" {
  name        = local.core_db_secret_id
  description = "Core DB"
  tags        = { Name = "${local.fqn}-secret-manager" }
}

resource "aws_secretsmanager_secret_version" "core_db" {
  secret_id     = aws_secretsmanager_secret.core_db.id
  secret_string = jsonencode(data.sops_file.core_db_secret.data)
}
