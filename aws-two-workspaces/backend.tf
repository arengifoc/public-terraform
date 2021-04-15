terraform {
  backend "s3" {
    bucket = "arengifoc-terraform-states"
    key = "aws-two-workspaces/terraform.tfstate"
    region = "us-east-1"
  }
}
