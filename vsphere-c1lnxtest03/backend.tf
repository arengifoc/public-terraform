terraform {
  backend "s3" {
    bucket = "arengifoc-terraform-states"
    key    = "vsphere-c1lnxtest03/terraform.tfstate"
    region = "us-east-1"
  }
}
