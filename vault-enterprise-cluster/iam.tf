resource "aws_iam_user" "iam_user" {
  name          = "vault_unseal_user"
  force_destroy = true
  tags          = var.tags
}

resource "aws_iam_access_key" "iam_access_key" {
  user     = aws_iam_user.iam_user.name
}

# IAM Inlice Policy for Vault IAM User
# This policy allows only the required seal/unseal tasks in Vault
resource "aws_iam_user_policy" "iam_user_policy" {
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
      "Resource": [
          "${aws_kms_key.vault_key_pri.arn}",
          "${aws_kms_key.vault_key_sec.arn}"
      ]
    }
  ]
}
EOF
}
