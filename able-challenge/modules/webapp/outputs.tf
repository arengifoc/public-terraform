output "rds_endpoint" {
  value = module.rds.this_db_instance_address
}

output "elb_endpoint" {
  value = "${var.backend_protocol}://${module.elb.this_lb_dns_name}:${var.backend_port}"

}
