resource "aws_iam_user" "iam_user" {
  count         = var.create_kms_key == true ? 1 : 0
  name          = var.iam_vault_user
  force_destroy = var.force_destroy_iam_vault_user
  tags          = var.tags
}

resource "aws_iam_access_key" "iam_access_key" {
  count = var.create_kms_key == true ? 1 : 0
  user  = aws_iam_user.iam_user[0].name
}

# IAM Inlice Policy for Vault IAM User
# This policy allows only the required seal/unseal tasks in Vault
resource "aws_iam_user_policy" "iam_user_policy" {
  count       = var.create_kms_key == true ? 1 : 0
  user        = aws_iam_user.iam_user[0].name
  name_prefix = var.iam_user_policy_prefix
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:DescribeKey"
      ],
      "Effect": "Allow",
      "Resource": ["${aws_kms_key.vault_key[0].arn}"]
    }
  ]
}
EOF
}

