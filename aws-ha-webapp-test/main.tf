terraform {
  backend "s3" {
    bucket         = "company-peru-terraform-states"
    key            = "dev/aws-ha-webapp-test/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "company-peru-terraform-states-locking"
  }
}
variable "region" {
  type    = string
  default = "us-east-1"
}

provider "aws" {
  region = var.region
}

module "webapp_stack" {
  source                      = "../../../modules/terraform-aws-ha-webapp-stack/"
  region                      = var.region
  name_prefix                 = "ha-webapp-stack"
  alb_access_logs_enabled     = true
  alb_in_ports                = ["80", "443"]
  subnet_ids                  = ["subnet-xxxxxxxx", "subnet-xxxxxxxx"] # at least 2 subnets in different AZs
  prevent_deletion            = false
  force_lblogs_bucket_destroy = true
  common_tags = {
    Owner     = "angel.rengifo"
    Group     = "Preventa MultiCloud Peru"
    Project   = "terraform tests"
    TFProject = "aws-ha-webapp-test"
  }
}
