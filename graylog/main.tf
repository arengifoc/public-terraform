# remote state using s3
terraform {
  backend "s3" {
    bucket = "sysadmin-company-arengifoc-terraform-states"
    key    = "dev/graylog/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  profile = var.AWS_PROFILE
  region  = var.REGION
}

# Busqueda y eleccion de la AMI deseada
data "aws_ami" "ami" {
  dynamic "filter" {
    for_each = var.AMIS[var.DESIRED_OS].name_pattern == null ? [] : [1]
    content {
      name   = "name"
      values = [var.AMIS[var.DESIRED_OS].name_pattern]
    }
  }

  dynamic "filter" {
    for_each = var.AMIS[var.DESIRED_OS].product_code == null ? [] : [1]
    content {
      name   = "product-code"
      values = [var.AMIS[var.DESIRED_OS].product_code]
    }
  }

  filter {
    name   = "root-device-type"
    values = [var.AMIS[var.DESIRED_OS].disk_type]
  }

  most_recent = true
  owners      = [var.AMIS[var.DESIRED_OS].owners]
}

data "aws_vpc" "selected" {
  tags = {
    Name = var.VPC_NAME
  }
}

data "aws_subnet" "selected" {
  tags = {
    Name = var.SUBNET_NAME
  }
  vpc_id = data.aws_vpc.selected.id
}

data "aws_security_group" "selected" {
  count  = length(var.SECURITY_GROUP_NAMES)
  vpc_id = data.aws_vpc.selected.id
  tags = {
    Name = var.SECURITY_GROUP_NAMES[count.index]
  }
}

resource "aws_instance" "graylog-node" {
  count                  = var.GRAYLOG_INSTANCE_COUNT
  instance_type          = var.GRAYLOG_INSTANCE_TYPE
  subnet_id              = data.aws_subnet.selected.id
  ami                    = data.aws_ami.ami.id
  key_name               = var.KEY_NAME
  vpc_security_group_ids = data.aws_security_group.selected.*.id
  iam_instance_profile   = var.IAM_INSTANCE_PROFILE

  tags = {
    Name             = "${var.TAG_NAME}-${var.AMIS[var.DESIRED_OS].short_name}-${count.index + 1}"
    Owner            = var.TAG_OWNER
    Team             = var.TAG_TEAM
    TerraformProject = var.TAG_TERRAFORM_PROJECT
  }
}

output "public_ip" {
  value = {
    for instance in aws_instance.graylog-node :
    "${instance.id} / ${instance.tags["Name"]} / ${instance.private_ip}" => "ssh -l ${var.AMIS[var.DESIRED_OS].default_user} ${instance.public_ip}"
  }
  description = "IP publica de la instancia"
}
