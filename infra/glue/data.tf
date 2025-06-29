data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "${var.env}-data-pipeline-sample-tfstate"
    key    = "network/terraform.tfstate"
  }
}

# Get available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# Get network route tables
data "aws_route_tables" "network" {
  vpc_id = data.terraform_remote_state.network.outputs.vpc.id
}


data "terraform_remote_state" "rds_core" {
  backend = "s3"
  config = {
    bucket = "${var.env}-data-pipeline-sample-tfstate"
    key    = "rds/core/terraform.tfstate"
  }
}

data "terraform_remote_state" "credential_core_db" {
  backend = "s3"
  config = {
    bucket = "${var.env}-data-pipeline-sample-tfstate"
    key    = "credential/core_db/terraform.tfstate"
  }
}

data "terraform_remote_state" "s3" {
  backend = "s3"
  config = {
    bucket = "${var.env}-data-pipeline-sample-tfstate"
    key    = "s3/terraform.tfstate"
  }
}
