provider "aws" {
  default_tags {
    tags = {
      Project = var.project
      Env     = var.env
      Managed = "terraform"
    }
  }
}

terraform {
  required_version = "1.9.5"
  backend "s3" {
    bucket = "stg-data-pipeline-sample-tfstate"
    key    = "rds/core/terraform.tfstate"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}
