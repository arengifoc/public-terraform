resource "aws_iam_user" "iam_user" {
  provider      = aws.primary
  name          = "vault_unseal_user"
  force_destroy = true
  tags          = var.tags
}

resource "aws_iam_access_key" "iam_access_key" {
  provider = aws.primary
  user     = aws_iam_user.iam_user.name
}

# IAM Inlice Policy for Vault IAM User
# This policy allows only the required seal/unseal tasks in Vault
resource "aws_iam_user_policy" "iam_user_policy" {
  provider    = aws.primary
  user        = aws_iam_user.iam_user.name
  name_prefix = "kms_policy_"
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
      "Resource": ["${aws_kms_key.primary_vault_key[0].arn}"${length(local.secondary_vault_ips) > 0 ? ",\"${aws_kms_key.secondary_vault_key[0].arn}\"" : ""}]
    }
  ]
}
EOF
}

