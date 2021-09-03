terraform {
  source = "../../tf-modules/terraform-aws-ec2demo"
}

inputs = {
  sg_rules = [
    "22,tcp,0.0.0.0/0"
  ]

  assign_public_ip = true
  random_suffix    = false
  name_prefix      = "jenkins"
  instance_count   = 1
  desired_os       = "Ubuntu Server 18.04"
  instance_type    = "t3a.micro"
  # user_data        = file("user_data.sh")

  tags = {
    "owner"     = "arengifoc"
    "tfproject" = "ec2demo"
  }
}
