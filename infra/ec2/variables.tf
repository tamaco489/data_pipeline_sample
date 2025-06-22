variable "env" {
  description = "The environment in which the ec2 will be created"
  type        = string
  default     = "stg"
}

variable "project" {
  description = "The project name"
  type        = string
  default     = "data-pipeline-sample"
}

variable "ami_id" {
  description = "The ami id to use for the ec2 instance"
  type        = string
  default     = "ami-0bb2c57f7cfafb1cb"
}

variable "instance_type" {
  description = "The instance type to use for the ec2 instance"
  type        = string
  default     = "t2.nano"
}

locals {
  fqn = "${var.env}-${var.project}"
}
