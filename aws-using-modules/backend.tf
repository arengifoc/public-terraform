terraform {
  backend "s3" {
    bucket     = "arengifoc-terraform-states"
    key        = "aws-using-modules/terraform.tfstate"
    region     = "us-east-1"
    access_key = "*"
    secret_key = "*"
  }
}
