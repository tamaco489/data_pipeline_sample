data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "${var.env}-data-pipeline-sample-tfstate"
    key    = "network/terraform.tfstate"
  }
}

data "terraform_remote_state" "bastion" {
  backend = "s3"
  config = {
    bucket = "${var.env}-data-pipeline-sample-tfstate"
    key    = "ec2/terraform.tfstate"
  }
}

data "terraform_remote_state" "credential_core_db" {
  backend = "s3"
  config = {
    bucket = "${var.env}-data-pipeline-sample-tfstate"
    key    = "credential/core_db/terraform.tfstate"
  }
}
