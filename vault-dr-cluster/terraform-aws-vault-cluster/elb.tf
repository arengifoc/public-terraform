# Create a primary application load balancer
module "elb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "5.6.0"

  name_prefix        = var.elb_name_prefix
  load_balancer_type = "network"
  vpc_id             = var.vpc_id
  subnets            = local.public_subnet_ids
  #   security_groups            = [module.sg_elb.this_security_group_id]
  enable_deletion_protection = var.enable_deletion_protection
  idle_timeout               = 60
  internal                   = var.elb_internal
  ip_address_type            = "ipv4"
  tags                       = var.tags

  target_groups = [
    {
      name_prefix      = var.elb_name_prefix
      backend_protocol = lookup(var.vault_vars, "vault_tls_disable", "1") == "1" ? "TCP" : "TLS"
      backend_port     = var.vault_port
      target_type      = "instance"

      health_check = {
        enabled           = true
        interval          = var.elb_health_check_interval
        path              = var.vault_health_check_path
        port              = tostring(var.vault_port)
        healthy_threshold = var.elb_health_check_healthy_threshold
        protocol          = lookup(var.vault_vars, "vault_tls_disable", "1") == "1" ? "HTTP" : "HTTPS"
      }

      # stickiness = {
      #   enabled = var.elb_stickiness_enabled
      # }
    }
  ]

  # certificate_arn    = aws_acm_certificate.vault_certificate.arn
  https_listeners = [
    {
      port               = var.elb_listener_port
      protocol           = var.elb_listener_protocol
      certificate_arn    = var.certificate_arn
      target_group_index = 0
    }
  ]

}

# Attach the primary vault EC2 instances to this primary load balancer
resource "aws_lb_target_group_attachment" "tg_attachment" {
  count            = length(local.vault_ips)
  target_group_arn = module.elb.target_group_arns[0]
  target_id        = module.ec2_vault.id[count.index]
  port             = var.vault_port
  depends_on       = [module.ec2_vault]
}
