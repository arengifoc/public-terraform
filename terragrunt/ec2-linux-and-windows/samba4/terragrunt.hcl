terraform {
  source = "../../../tf-modules/terraform-aws-ec2demo"
}

inputs = {
  sg_rules         = ["22,tcp,10.0.0.0/8", "0,-1,10.216.21.128/26"]
  name_prefix      = "samba4"
  random_suffix    = true
  assign_public_ip = false
  instance_count   = 1
  desired_os       = "Ubuntu Server 18.04"
  instance_type    = "t3a.small"
  user_data        = file("user_data.sh")

  tags = {
    "owner"       = "acancino"
    "provisioner" = "manual/acancino"
    "tfproject"   = "ec2-linux-and-windows"
  }
}
