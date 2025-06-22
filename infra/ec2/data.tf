data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "${var.env}-data-pipeline-sample-tfstate"
    key    = "network/terraform.tfstate"
  }
}
