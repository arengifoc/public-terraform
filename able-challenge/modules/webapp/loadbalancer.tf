module "sg_elb" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.16.0"

  name         = "${var.name_prefix}-sg-elb"
  description  = "SG for incoming Load Balancer traffic"
  vpc_id       = module.network.vpc_id
  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

module "elb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "5.10.0"

  name_prefix                = var.name_prefix
  load_balancer_type         = "application"
  vpc_id                     = module.network.vpc_id
  subnets                    = module.network.public_subnets
  security_groups            = [module.sg_elb.this_security_group_id]
  enable_deletion_protection = false
  enable_http2               = true
  idle_timeout               = 60
  internal                   = false
  ip_address_type            = "ipv4"
  tags                       = var.tags

  target_groups = [
    {
      name_prefix      = "${var.name_prefix}-tg"
      backend_protocol = var.backend_protocol
      backend_port     = var.backend_port
      target_type      = "instance"

      stickiness = {
        enabled = var.stickiness_enabled
        type    = "lb_cookie"
      }
    }
  ]
  #   health_check = {
  #     enabled             = true
  #     interval            = var.alb_health_check_interval
  #     path                = var.vault_health_check_path
  #     port                = tostring(var.vault_port)
  #     healthy_threshold   = var.alb_health_check_healthy_threshold
  #     unhealthy_threshold = var.alb_health_check_unhealthy_threshold
  #     timeout             = var.alb_health_check_timeout
  #     protocol            = var.vault_tls_disable == 1 ? "HTTP" : "HTTPS"
  #     matcher             = var.alb_health_check_matcher
  #   }

  https_listeners = var.backend_protocol == "HTTPS" ? [
    {
      port               = var.backend_port
      protocol           = var.backend_protocol
      certificate_arn    = var.certificate_arn
      target_group_index = 0
    }
  ] : []

  http_tcp_listeners = var.backend_protocol == "HTTP" ? [
    {
      port               = var.backend_port
      protocol           = var.backend_protocol
      action_type        = "forward"
      target_group_index = 0
    }
  ] : []
}

resource "aws_lb_target_group_attachment" "tg_attachment" {
  count            = var.webapp_count
  target_group_arn = module.elb.target_group_arns[0]
  target_id        = module.ec2_ec2.id[count.index]
  port             = var.backend_port
  depends_on       = [module.ec2_ec2]
}
