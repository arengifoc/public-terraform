terraform {
  backend "s3" {
    bucket                  = "arengifoc-terraform-states"
    key                     = "terraform_vsphere_wingenesys/terraform_vsphere_wingenesys.tfstate"
    region                  = "us-east-1"
    shared_credentials_file = "~/.aws/credentials"
  }
}
