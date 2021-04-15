module "globals" {
  source = "../modules/globals"
}

module "network" {
  source      = "../modules/existing-infrastructure"
  vpc_name    = "${var.vpc_name}"
  subnet_name = "${var.subnet_name}"
}

data "aws_ami" "selected" {
  most_recent = true
  owners      = ["${lookup(module.globals.ami_owners, var.owner_name)}"]

  filter {
    name   = "name"
    values = ["${lookup(module.globals.ami_patterns, var.ami_name)}"]
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

module "vm1" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  ami                    = "${data.aws_ami.selected.image_id}"
  vpc_security_group_ids = ["sg-01f16cd4ac7137852"]
  instance_type          = "${var.instance_type}"

  name      = "${var.instance_name}"
  subnet_id = "${module.network.subnet_id}"
  private_ip = "${var.private_ip}"
  #key_name = "${var.key_name}"

  root_block_device = [
    {
      volume_size = "${var.os_rootfs_disk_size}"
      volume_type = "${var.os_rootfs_disk_type}"
    },
  ]
}
