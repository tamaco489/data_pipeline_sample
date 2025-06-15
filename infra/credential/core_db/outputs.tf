output "core_db" {
  value = {
    name = aws_secretsmanager_secret.core_db.name
    arn  = aws_secretsmanager_secret.core_db.arn
  }
}
