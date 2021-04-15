# remote state using s3
terraform {
  backend "s3" {
    bucket         = "company-terraform-states"
    key            = "dev/ec2-import/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "company-terraform-states-locking"
  }
}

provider "aws" {
  # profile = var.AWS_PROFILE
  region = var.REGION
}


# EC2 instance
resource "aws_instance" "ec2instance" {
  # manually defined code after terraform import & terraform state show

  # subnet_id = "subnet-xxxxxxxx"
  # ami       = "ami-0323c3dd2da7fb37d"
  # vpc_security_group_ids = [
  #   "sg-05e10b4e113145e07",
  # ]
  # associate_public_ip_address = true
  # instance_type               = "t3a.nano"
  # key_name                    = "kp-angel.rengifo"
  # root_block_device {
  #   delete_on_termination = true
  #   volume_size           = 12
  # }
  # tags = {
  #   "Name"    = "demo-tf-import"
  #   Owner     = "angel.rengifo"
  #   Group     = "Preventa Multi Cloud Peru"
  #   Project   = "Demo Terraform import"
  #   TFProject = "ec2-import"
  # }

  # ebs_optimized = true
}

