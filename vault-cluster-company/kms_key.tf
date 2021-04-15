resource "aws_kms_key" "primary_vault_key" {
  provider                = aws.primary
  count                   = length(var.primary_network_settings) > 0 ? 1 : 0
  description             = "Primary KMS key for unsealing Vault"
  deletion_window_in_days = 7
  tags                    = var.tags
}

resource "aws_kms_alias" "primary_vault_key_alias" {
  provider      = aws.primary
  count         = length(var.primary_network_settings) > 0 ? 1 : 0
  name_prefix   = "alias/vault_key_"
  target_key_id = aws_kms_key.primary_vault_key[0].id
}

resource "aws_kms_key" "secondary_vault_key" {
  provider                = aws.secondary
  count                   = length(var.secondary_network_settings) > 0 ? 1 : 0
  description             = "Secondary KMS key for unsealing Vault"
  deletion_window_in_days = 7
  tags                    = var.tags
}

resource "aws_kms_alias" "secondary_vault_key_alias" {
  provider      = aws.secondary
  count         = length(var.secondary_network_settings) > 0 ? 1 : 0
  name_prefix   = "alias/vault_key_"
  target_key_id = aws_kms_key.secondary_vault_key[0].id
}
