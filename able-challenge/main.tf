provider "aws" {
  region = var.region
}

variable "public_sshkey" {}
variable "name_prefix" {}
variable "admin_username" {}
variable "region" {}
variable "webapp_count" {}

module "webapp" {
  source = "./modules/webapp"

  public_sshkey   = var.public_sshkey
  name_prefix     = var.name_prefix
  webapp_count    = var.webapp_count
  db_name         = "${var.name_prefix}db"
  db_identifier   = "${var.name_prefix}rds"
  master_password = random_password.rds.result
  master_username = var.admin_username
}

resource "random_password" "rds" {
  length  = 20
  special = false
}
