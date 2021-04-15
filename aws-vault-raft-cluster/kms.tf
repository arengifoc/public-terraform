resource "aws_kms_key" "vault_key" {
  description             = "KMS key for unsealing Vault"
  deletion_window_in_days = 7
  tags                    = var.tags
}

resource "aws_kms_alias" "vault_key_alias" {
  name_prefix   = "alias/vault_key_"
  target_key_id = aws_kms_key.vault_key.id
}

resource "aws_iam_user" "iam_user" {
  name          = "vault_unseal_user"
  force_destroy = true
  tags          = var.tags
}

resource "aws_iam_access_key" "iam_access_key" {
  user = aws_iam_user.iam_user.name
}

# IAM Inlice Policy for Vault IAM User
# This policy allows only the required seal/unseal tasks in Vault
resource "aws_iam_user_policy" "iam_user_policy" {
  user        = aws_iam_user.iam_user.name
  name_prefix = "kms_policy_"
  policy      = data.aws_iam_policy_document.user_policy.json
}

data "aws_iam_policy_document" "user_policy" {
  statement {
    sid    = "KMSUsage"
    effect = "Allow"

    resources = [
      aws_kms_key.vault_key.arn
    ]

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey"
    ]
  }
}
