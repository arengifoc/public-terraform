terraform {
  backend "s3" {
    bucket         = "company-peru-terraform-states"
    key            = "dev/ec2-module-usage/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "company-peru-terraform-states-locking"
  }
}

provider "aws" {
  region = var.aws_region
}

module "ec2_instance" {
  source = "../../../modules/ec2-demo/"

  instance_count       = var.instance_count
  desired_os           = var.desired_os
  instance_type        = var.instance_type
  vpc_name             = var.vpc_name
  subnet_name          = var.subnet_name
  security_group_names = var.security_group_names
  tag_name             = var.tag_name
  tag_owner            = var.tag_owner
  tag_project          = var.tag_project
  tag_group            = var.tag_group
  tag_tf_project       = var.tag_tf_project
}
