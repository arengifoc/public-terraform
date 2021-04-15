resource "aws_kms_key" "vault_key" {
  count                   = var.create_kms_key == true ? 1 : 0
  description             = "KMS key for unsealing Vault"
  deletion_window_in_days = 7
  tags                    = var.tags
}

resource "aws_kms_alias" "vault_key_alias" {
  count         = var.create_kms_key == true ? 1 : 0
  name_prefix   = "alias/vault_key_"
  target_key_id = aws_kms_key.vault_key[0].id
}
