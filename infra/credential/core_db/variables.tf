variable "env" {
  description = "The environment in which the Core DB Secret Manager will be created"
  type        = string
  default     = "stg"
}

variable "project" {
  description = "The project name"
  type        = string
  default     = "data-pipeline-sample"
}

locals {
  fqn               = "${var.env}-${var.project}"
  core_db_secret_id = "core/${var.env}/rds-cluster"
}
