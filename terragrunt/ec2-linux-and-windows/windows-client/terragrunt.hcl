terraform {
  source = "../../../tf-modules/terraform-aws-ec2demo"
}

inputs = {
  sg_rules               = ["3389,tcp,10.0.0.0/8", "0,-1,10.216.21.128/26"]
  name_prefix            = "win2k16"
  random_suffix          = true
  assign_public_ip       = false
  instance_count         = 1
  desired_os             = "Windows 2016"
  instance_type          = "t3a.medium"
  root_block_device_size = 30

  tags = {
    "owner"       = "acancino"
    "provisioner" = "manual/acancino"
    "tfproject"   = "ec2-linux-and-windows"
  }
}
