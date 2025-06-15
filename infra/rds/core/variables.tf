variable "env" {
  description = "The environment in which the core rds will be created"
  type        = string
  default     = "stg"
}

variable "project" {
  description = "The project name"
  type        = string
  default     = "data-pipeline-sample"
}

locals {
  fqn = "${var.env}-${var.project}"
}
