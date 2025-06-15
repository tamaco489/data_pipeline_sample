# =================================================================
# general
# =================================================================
variable "env" {
  description = "The environment in which the shop api vpc lambda will be created"
  type        = string
  default     = "stg"
}

variable "project" {
  description = "The project name"
  type        = string
  default     = "data-pipeline-sample"
}

variable "region" {
  description = "The region in which the shop api vpc lambda will be created"
  type        = string
  default     = "ap-northeast-1"
}

variable "product" {
  description = "The product name"
  type        = string
  default     = "shop"
}

locals {
  fqn = "${var.env}-${var.product}"
}
