terraform {
  source = "../../../tf-modules/terraform-aws-ec2demo"
}

inputs = {
  sg_rules               = ["3306,tcp,172.31.0.0/16","22,tcp,172.31.0.0/16","80,tcp,172.31.0.0/16"]
  name_prefix            = "mysql-server"
  random_suffix          = true
  assign_public_ip       = false
  instance_count         = 1
  root_block_device_size = 10
  desired_os             = "Ubuntu Server 18.04"

  tags = {
    "tfproject" = "ec2-ssh-tunneling/internal"
  }
}
