data "aws_vpc" "selected" {
  id = "${var.vpc_id}"
}

data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.selected.id}"
}

data "aws_subnet" "selected" {
  filter {
    name   = "tag:Name"
    values = ["${var.subnet_filter}"]
  }

  vpc_id = "${data.aws_vpc.selected.id}"
}

output "subnet_ids" {
  value = ["${data.aws_subnet.selected.*.id}"]
}

output "subnet_tags" {
  value = ["${data.aws_subnet.selected.*.tags}"]
}

output "subnet_azs" {
  value = ["${data.aws_subnet.selected.*.availability_zone}"]
}

data "aws_ami" "aws_ami" {
  most_recent = true
  owners      = ["${lookup(var.ami_owners, var.owner_name)}"]

  filter {
    name   = "name"
    values = ["${lookup(var.ami_patterns, var.ami_name)}"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

module "SG1" {
  source       = "terraform-aws-modules/security-group/aws"
  vpc_id       = "${data.aws_vpc.selected.id}"
  name         = "SG_sg1"
  description  = "1st security group"
  egress_rules = ["all-all"]

  ingress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp"
      cidr_blocks = "179.6.220.186/32"
    },
  ]
}

module "vm1" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["${module.SG1.this_security_group_id}"]
  ami                         = "${data.aws_ami.aws_ami.id}"
  name                        = "${var.instance_name}"
  subnet_id                   = "${data.aws_subnet.selected.id}"
  associate_public_ip_address = true
  key_name                    = "KP-arengifoc2"
  instance_count              = 1

  root_block_device = [
    {
      volume_size = "${var.os_rootfs_disk_size}"
      volume_type = "gp2"
    },
  ]

  ebs_block_device = [
    {
      device_name = "/dev/sdf"
      volume_size = "${var.os_swap_disk_size}"
      volume_type = "gp2"
    },
  ]

  tags = {
    comments = "Created by Terraform"
  }
}
