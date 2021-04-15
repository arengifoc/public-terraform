# remote state using s3
terraform {
  backend "s3" {
    bucket = "sysadmin-company-arengifoc-terraform-states"
    key    = "dev/beanstalk-testjavaweb/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  profile = var.AWS_PROFILE
  region  = var.REGION
}


resource "aws_elastic_beanstalk_application" "tftest" {
  name        = var.APP_NAME
  description = var.APP_DESCRIPTION

  appversion_lifecycle {
    service_role          = var.SERVICE_ROLE
    max_count             = var.MAX_VERSIONS
    delete_source_from_s3 = true
  }

  tags = {
    Owner = var.TAG_OWNER
  }
}
