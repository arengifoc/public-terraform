# remote state using s3
terraform {
  backend "s3" {
    bucket = "sysadmin-company-arengifoc-terraform-states"
    key    = "dev/aws-ec2-k8s/terraform.tfstate"
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
    for_each = var.AMIS[var.DESIRED_AMI].name_pattern == null ? [] : [1]
    content {
      name   = "name"
      values = [var.AMIS[var.DESIRED_AMI].name_pattern]
    }
  }

  dynamic "filter" {
    for_each = var.AMIS[var.DESIRED_AMI].product_code == null ? [] : [1]
    content {
      name   = "product-code"
      values = [var.AMIS[var.DESIRED_AMI].product_code]
    }
  }

  most_recent = true
  owners      = [var.AMIS[var.DESIRED_AMI].owners]
}


resource "aws_instance" "vm-test" {
  count                  = var.INSTANCE_COUNT
  instance_type          = var.INSTANCE_TYPE
  ami                    = data.aws_ami.ami.id
  subnet_id              = var.SUBNET_ID
  key_name               = var.KEY_NAME
  vpc_security_group_ids = var.SECURITY_GROUP_IDS
  iam_instance_profile   = var.IAM_INSTANCE_PROFILE

  tags = {
    Name  = "${var.TAG_NAME}-${var.AMIS[var.DESIRED_AMI].short_name}-${count.index + 1}"
    Owner = var.TAG_OWNER
    Team  = var.TAG_TEAM
  }
}

output "public_ip" {
  value       = aws_instance.vm-test.*.public_ip
  description = "IP publica de la instancia"
}
