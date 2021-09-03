terraform {
  source = "../../../tf-modules/terraform-aws-ec2demo"
}

inputs = {
  sg_rules         = ["22,tcp,0.0.0.0/0","3128,tcp,172.31.0.0/16"]
  name_prefix      = "bastion"
  random_suffix    = true
  assign_public_ip = true
  instance_count   = 1
  desired_os       = "Ubuntu Server 18.04"
  instance_type    = "t3a.nano"

  tags = {
    "tfproject"   = "ec2-ssh-tunneling/bastion"
  }
}
