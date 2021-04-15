provider "aws" {
  region = "us-east-1"
}

# Create security groups for bastion servers
module "sg_moodle_ami" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.10.0"

  name         = "sg_moodle_ami"
  description  = "SG for moodle_ami host"
  vpc_id       = var.vpc_id
  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH service"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP service"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

module "sg_ceph" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.10.0"

  name         = "sg_ceph"
  description  = "SG for moodle_ami host"
  vpc_id       = var.vpc_id
  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH service"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 6800
      to_port     = 7300
      protocol    = "tcp"
      description = "Ceph OSD service"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 6789
      to_port     = 6789
      protocol    = "tcp"
      description = "Ceph monitor service"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 3300
      to_port     = 3300
      protocol    = "tcp"
      description = "Ceph monitor service"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

module "moodle_ami" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.13.0"

  name                        = "moodle_ami"
  instance_count              = 1
  ami                         = "ami-061811a81c7a6c1e0"
  instance_type               = "t3a.micro"
  key_name                    = "kp-angel.rengifo"
  monitoring                  = false
  vpc_security_group_ids      = [module.sg_moodle_ami.this_security_group_id]
  subnet_ids                  = [var.subnet_id]
  associate_public_ip_address = true
  tags                        = var.tags
}

module "ceph" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.13.0"

  name                        = "ceph"
  instance_count              = 3
  ami                         = data.aws_ami.selected.id
  instance_type               = "t3a.micro"
  key_name                    = "kp-angel.rengifo"
  monitoring                  = false
  vpc_security_group_ids      = [module.sg_ceph.this_security_group_id]
  subnet_ids                  = [var.subnet_id]
  associate_public_ip_address = true
  tags                        = var.tags
}

resource "aws_volume_attachment" "ebs_attach_ceph1" {
  count = 2

  device_name = element(var.data_volume_device_list, count.index)
  volume_id   = aws_ebs_volume.ebs_ceph1[count.index].id
  instance_id = module.ceph.id[0]
}

resource "aws_volume_attachment" "ebs_attach_ceph2" {
  count = 2

  device_name = element(var.data_volume_device_list, count.index)
  volume_id   = aws_ebs_volume.ebs_ceph2[count.index].id
  instance_id = module.ceph.id[1]
}

resource "aws_volume_attachment" "ebs_attach_ceph3" {
  count = 2

  device_name = element(var.data_volume_device_list, count.index)
  volume_id   = aws_ebs_volume.ebs_ceph3[count.index].id
  instance_id = module.ceph.id[2]
}

resource "aws_ebs_volume" "ebs_ceph1" {
  count = 2

  availability_zone = module.ceph.availability_zone[0]
  size              = 15
}

resource "aws_ebs_volume" "ebs_ceph2" {
  count = 2

  availability_zone = module.ceph.availability_zone[1]
  size              = 15
}

resource "aws_ebs_volume" "ebs_ceph3" {
  count = 2

  availability_zone = module.ceph.availability_zone[2]
  size              = 15
}




# module "sg_efs" {
#   source  = "terraform-aws-modules/security-group/aws"
#   version = "3.10.0"

#   name         = "sg_efs"
#   description  = "SG for efs host"
#   vpc_id       = var.vpc_id
#   egress_rules = ["all-all"]
#   ingress_with_cidr_blocks = [
#     {
#       from_port   = 2049
#       to_port     = 2049
#       protocol    = "tcp"
#       description = "nfs service"
#       cidr_blocks = "0.0.0.0/0"
#     }
#   ]
# }

# resource "aws_efs_file_system" "efs" {
#   performance_mode = "generalPurpose"
#   throughput_mode  = "bursting"
#   tags             = var.tags
# }

# resource "aws_efs_mount_target" "mt" {
#   file_system_id  = aws_efs_file_system.efs.id
#   subnet_id       = var.subnet_id
#   security_groups = [module.sg_efs.this_security_group_id]
# }
