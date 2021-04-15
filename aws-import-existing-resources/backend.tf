terraform {
  backend "s3" {
    bucket = "arengifoc-terraform-states"
    key    = "aws-import-existing-resources/terraform.tfstate"
    region = "us-east-1"
  }
}
