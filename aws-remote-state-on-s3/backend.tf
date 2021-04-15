terraform {
  backend "s3" {
    bucket = "arengifoc-terraform-states"
    key = "aws-remote-state-on-s3/terraform.tfstate"
    region = "us-east-1"
  }
}
