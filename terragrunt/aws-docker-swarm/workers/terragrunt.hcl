terraform {
  source = "../../../tf-modules/terraform-aws-ec2demo"
}

inputs = {
  sg_rules         = ["22,tcp,0.0.0.0/0", "2377,tcp,172.31.0.0/16"]
  name_prefix      = "swarm-worker"
  random_suffix    = false
  assign_public_ip = true
  instance_count   = 2
  user_data        = file("user_data.sh")

  tags = {
    "owner"     = "arengifoc"
    "tfproject" = "aws-swarm-cluster"
  }
}