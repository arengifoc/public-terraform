resource "aws_lb" "alb" {
  load_balancer_type         = "application"
  name_prefix                = var.name_prefix
  internal                   = var.is_internal
  ip_address_type            = var.ip_address_type
  subnets                    = var.subnet_ids
  security_groups            = [aws_security_group.alb_sg.id]
  idle_timeout               = var.idle_timeout
  enable_http2               = var.enable_http2
  enable_deletion_protection = var.prevent_deletion
  tags = merge(
    {
      Name = "ALB_${var.name_prefix}"
    },
    var.tags
  )

  access_logs {
    bucket  = aws_s3_bucket.lblogs_bucket.id
    prefix  = var.lblogs_prefix_path
    enabled = var.alb_access_logs_enabled
  }
}

resource "aws_s3_bucket_policy" "lblogs_bucket_policy" {
  bucket = aws_s3_bucket.lblogs_bucket.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.elb_account_id[var.region].account_id}:root"
      },
      "Action": "s3:PutObject",
      "Resource": "${aws_s3_bucket.lblogs_bucket.arn}/${var.lblogs_prefix_path}/*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "${aws_s3_bucket.lblogs_bucket.arn}/${var.lblogs_prefix_path}/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "${aws_s3_bucket.lblogs_bucket.arn}"
    }
  ]
}
EOF
}

# S3 bucket for the LB access logs
resource "aws_s3_bucket" "lblogs_bucket" {
  bucket_prefix = var.name_prefix
  force_destroy = var.force_lblogs_bucket_destroy
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = merge(
    {
      Name = "Bucket_ALBLogs_${var.name_prefix}"
    },
    var.tags
  )
}

# data source for discovering network information from subnets
data "aws_subnet" "selected" {
  id = var.subnet_ids[0]
}

# security group for the load balancer
resource "aws_security_group" "alb_sg" {
  name_prefix = var.name_prefix
  vpc_id      = data.aws_subnet.selected.vpc_id
  tags = merge(
    {
      Name = "SG_ALB_${var.name_prefix}"
    },
    var.tags
  )
}

# security group rule: allow all outgoing traffic
resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

# security group rules: allow certain incoming traffic based on ports defined in alb_in_ports
resource "aws_security_group_rule" "this" {
  for_each          = toset(var.alb_in_ports)
  type              = "ingress"
  from_port         = each.value
  to_port           = each.value
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

resource "aws_lb_target_group" "alb_tg" {
  target_type          = "instance"
  vpc_id               = data.aws_subnet.selected.vpc_id
  deregistration_delay = var.deregistration_delay
  name_prefix          = var.name_prefix

  port     = var.tg_port
  protocol = var.tg_protocol
  tags     = var.tags

  health_check {
    enabled             = var.health_check_enabled
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    path                = var.health_check_path
    port                = var.health_check_port
    protocol            = var.health_check_protocol
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    matcher             = var.health_check_matcher
  }

  stickiness {
    type            = "lb_cookie"
    enabled         = var.stickiness_enabled
    cookie_duration = var.stickiness_duration
  }
}

resource "aws_lb_target_group_attachment" "tg_attachment" {
  for_each         = toset(var.instance_ids)
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = each.value
  port             = var.instance_port
}

# resource "aws_lb_listener" "lb_listener" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = ""
#   protocol          = "HTTPS"

#   default_action {
#     type = "forward"
#     target_group_arn
#   }
# }
