resource "tls_private_key" "vault" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_self_signed_cert" "vault" {
  key_algorithm         = tls_private_key.vault.algorithm
  private_key_pem       = tls_private_key.vault.private_key_pem
  validity_period_hours = "8760" # 1 year
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth"
  ]
  subject {
    common_name = "*.${var.vault_domain}"
  }
}

resource "tls_private_key" "samba" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_self_signed_cert" "samba" {
  key_algorithm         = tls_private_key.samba.algorithm
  private_key_pem       = tls_private_key.samba.private_key_pem
  validity_period_hours = "8760"
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth"
  ]
  subject {
    common_name = "${var.samba_hostname}.${var.samba_domain}"
  }
}
