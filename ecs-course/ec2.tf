resource "aws_key_pair" "this" {
  key_name   = "acancino-kp"
  public_key = file("~/.ssh/id_rsa.pub")
  tags       = var.tags
}

resource "aws_security_group" "this" {
  name   = "acancino-sg"
  vpc_id = var.vpc_id
  tags   = var.tags
}

resource "aws_security_group_rule" "this_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "this_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "this_postgres" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.this.id
  security_group_id        = aws_security_group.this.id
}

resource "aws_security_group_rule" "this_redis" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.this.id
  security_group_id        = aws_security_group.this.id
}

resource "aws_security_group_rule" "this_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}

module "ami" {
  source = "git::https://gitlab.com/arengifoc/terraform-aws-data-amis.git"
  os     = "Amazon Linux 2"
}

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.17.0"

  instance_count              = 1
  name                        = "${var.name_prefix}-ec2"
  ami                         = module.ami.id
  instance_type               = "t3a.medium"
  iam_instance_profile        = aws_iam_instance_profile.this_ec2.id
  key_name                    = aws_key_pair.this.key_name
  monitoring                  = false
  vpc_security_group_ids      = [aws_security_group.this.id]
  subnet_ids                  = [var.subnet_id]
  associate_public_ip_address = false
  tags                        = var.tags
  user_data = templatefile(
    "${path.module}/templates/userdata.sh.tpl",
    {
      bucket_name = aws_s3_bucket.this.id
    }
  )
}
