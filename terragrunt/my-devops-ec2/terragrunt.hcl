terraform {
  source = "../../tf-modules/terraform-aws-ec2demo"
}

inputs = {
  sg_rules         = ["22,tcp,179.6.32.76/32"]
  name_prefix      = "my-devops-ec2"
  assign_public_ip = true
  random_suffix    = false
  instance_count   = 1
  desired_os       = "Ubuntu Server 18.04"
  instance_type    = "t3a.nano"
  user_data        = file("user_data.sh")
  tags = {
    "owner"       = "arengifoc"
    "tfproject"   = "my-devops-ec2"
  }
  iam_json_policy  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["ec2:*","s3:*","iam:*"],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}
