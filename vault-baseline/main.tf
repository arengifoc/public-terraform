terraform {
  backend "s3" {
    bucket  = "arengifoc-tfstate"
    key     = "dev/vault-baseline/terraform.tfstate"
    region  = "us-east-1"
    profile = "arengifoc"
  }
}

provider vault {
  address         = data.terraform_remote_state.selected.outputs.vault_url
  token           = var.vault_token
  skip_tls_verify = true
}

data "terraform_remote_state" "selected" {
  backend = "s3"
  config = {
    bucket  = "arengifoc-tfstate"
    key     = "dev/aws-vault-raft-cluster/terraform.tfstate"
    region  = "us-east-1"
    profile = "arengifoc"
  }
}

resource "vault_audit" "file" {
  type = "file"
  options = {
    file_path = data.terraform_remote_state.selected.outputs.vault_audit_filename
  }
}

resource "vault_mount" "kv_jenkins" {
  path        = var.jenkins_path
  type        = "kv"
  description = "Secrets for Jenkins"
}
