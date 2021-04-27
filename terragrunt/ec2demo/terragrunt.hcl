terraform {
  source = "../../tf-modules/terraform-aws-ec2demo"
}

inputs = {
  sg_rules         = ["22,tcp,10.0.0.0/8"]
  assign_public_ip = false

  tags = {
    "owner" = "arengifoc"
  }
}
