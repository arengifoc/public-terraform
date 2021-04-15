output "server_fqdn" {
    value = module.postgres.server_fqdn
}

output "server_name" {
    value = module.postgres.server_name
}

output "server_id" {
    value = module.postgres.server_id
}

output "admin_login" {
    value = module.postgres.administrator_login
}

output "admin_password" {
    value = module.postgres.administrator_password
}

output "db_ids" {
    value = module.postgres.database_ids
}
