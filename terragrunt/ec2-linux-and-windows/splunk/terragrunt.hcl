terraform {
  source = "../../../tf-modules/terraform-aws-ec2demo"
}

inputs = {
  sg_rules               = ["22,tcp,10.0.0.0/8", "8000,tcp,10.0.0.0/8", "9997,tcp,10.216.21.128/26"]
  name_prefix            = "splunk"
  random_suffix          = true
  assign_public_ip       = false
  instance_count         = 1
  desired_os             = "Ubuntu Server 18.04"
  user_data              = file("user_data.sh")
  root_block_device_size = 20

  tags = {
    "owner"       = "acancino"
    "provisioner" = "manual/acancino"
    "tfproject"   = "ec2-linux-and-windows"
  }
}
