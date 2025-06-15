data "sops_file" "core_db_secret" {
  source_file = "tfvars/${var.env}_core_db.yaml"
}
