# stage/terragrunt.hcl
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "arengifoc-terraform-tfstate"

    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terragrunt-lock"
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = "us-east-2"
  assume_role {
    role_arn = "arn:aws:iam::003399163242:role/terraform_role"
  }
}
EOF
}

# Common arguments used when invoked terraform
terraform {
  # Use -auto-approve only on apply and destroy operations
  extra_arguments "common_args" {
    commands = ["apply","destroy"]

    arguments = [
      "-auto-approve"
    ]
  }
  #extra_arguments "common_vars" {
   # commands = get_terraform_commands_that_need_vars()

    #arguments = [
     # "-var-file=../../common.tfvars",
      #"-var-file=../region.tfvars"
    #]
  #}
}