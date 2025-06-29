# =================================================================
# general
# =================================================================
variable "env" {
  description = "The environment in which the glue resources will be created"
  type        = string
  default     = "stg"
}

variable "project" {
  description = "The project name"
  type        = string
  default     = "data-pipeline-sample"
}

variable "region" {
  description = "The region in which the glue resources will be created"
  type        = string
  default     = "ap-northeast-1"
}

variable "database_name" {
  description = "The name of the database to connect to"
  type        = string
  default     = "stg_core"
}

locals {
  fqn = "${var.env}-${var.project}"
}
