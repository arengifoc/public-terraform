# resource "aws_directory_service_directory" "ad" {
#   provider    = aws.primary
#   type        = "SimpleAD"
#   description = "Active Directory Service for integration with Vault"
#   name        = var.org_domain
#   short_name  = var.org_short_name
#   password    = var.ds_admin_pass
#   size        = "Small"
#   tags        = var.tags

#   vpc_settings {
#     vpc_id     = var.primary_vpc_id
#     subnet_ids = slice(local.primary_private_subnet_ids, 0, 2)
#   }
# }
