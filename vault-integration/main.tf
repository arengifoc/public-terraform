terraform {
  backend "s3" {
    bucket         = "company-peru-terraform-states"
    key            = "dev/vault-integration/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "company-peru-terraform-states-locking"
  }
}

# We get the dynamic credentials obtained from Vault by using a data source
provider "aws" {
  region     = "us-east-1"
  access_key = data.vault_aws_access_credentials.creds.access_key
  secret_key = data.vault_aws_access_credentials.creds.secret_key
}

# Empty vault provider definition. Its parameters are defined through environment variables:
# address: VAULT_ADDR
# token: VAULT_TOKEN
#
# we must manually get a valid token (i.e. by running vault login) previous to start working on this terraform project 
provider "vault" {
}

# We use dynamic aws secrets to get access key and secret access key that will be used by the aws provider
# These aws credentials have short duration
data "vault_aws_access_credentials" "creds" {
  backend = "aws_company"
  role    = "ec2-admin-role"
  type    = "creds"
}

# This is just for testing. We read a kv secret from vault. One of their keys will be used as bucket name
data "vault_generic_secret" "s3_info" {
  path = "secret/s3"
}

# We get the bucket name from the key "name" within the "s3" kv secret stored in Vault
resource "aws_s3_bucket" "bucket" {
  #   bucket = "company-peru-vault-demo-bucket"
  bucket = data.vault_generic_secret.s3_info.data["name"]
}
