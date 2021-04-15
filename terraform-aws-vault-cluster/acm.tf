# resource "aws_acm_certificate" "vault_certificate" {
#   certificate_chain = var.ca_cert_file
#   private_key       = var.server_key_file
#   certificate_body  = var.server_cert_file
#   tags = merge(
#     {
#       Name = var.vault_certificate_name
#     },
#     var.tags
#   )
# }
