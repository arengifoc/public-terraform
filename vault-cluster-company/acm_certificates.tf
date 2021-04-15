# resource "aws_acm_certificate" "primary_certificates" {
#   provider          = aws.primary
#   count             = fileexists("${path.module}/${var.ca_cert_file}") == true && fileexists("${path.module}/${var.server_key_file}") == true && fileexists("${path.module}/${var.server_cert_file}") == true ? 1 : 0
#   certificate_chain = file("${path.module}/${var.ca_cert_file}")
#   private_key       = file("${path.module}/${var.server_key_file}")
#   certificate_body  = file("${path.module}/${var.server_cert_file}")
#   tags = merge(
#     {
#       Name = "vault-${var.org_short_name}"
#     },
#     var.tags
#   )
# }

# resource "aws_acm_certificate" "secondary_certificates" {
#   provider          = aws.secondary
#   count             = fileexists("${path.module}/${var.ca_cert_file}") == true && fileexists("${path.module}/${var.server_key_file}") == true && fileexists("${path.module}/${var.server_cert_file}") == true ? 1 : 0
#   certificate_chain = file("${path.module}/${var.ca_cert_file}")
#   private_key       = file("${path.module}/${var.server_key_file}")
#   certificate_body  = file("${path.module}/${var.server_cert_file}")
#   tags = merge(
#     {
#       Name = "vault-${var.org_short_name}"
#     },
#     var.tags
#   )
# }
