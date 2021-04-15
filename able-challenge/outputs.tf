output "db_admin_pass" {
  value = random_password.rds.result
}

output "db_endpoint" {
    value = module.webapp.rds_endpoint
}

output "lb_endpoint" {
    value = module.webapp.elb_endpoint
}