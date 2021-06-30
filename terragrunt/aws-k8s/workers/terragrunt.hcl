terraform {
  source = "../../../tf-modules/terraform-aws-ec2demo"
}

inputs = {
  sg_rules = [
    "22,tcp,179.6.32.76/32",
    "-1,icmp,0.0.0.0/0",
    "-1,all,172.31.0.0/16"
  ]
  name_prefix      = "worker"
  assign_public_ip = true
  random_suffix    = false
  instance_count   = 1
  desired_os       = "Ubuntu Server 18.04"
  instance_type    = "t3a.small"
  tags = {
    "owner"     = "arengifoc"
    "tfproject" = "aws-k8s/worker"
  }
}
