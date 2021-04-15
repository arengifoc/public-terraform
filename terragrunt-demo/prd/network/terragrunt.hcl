include {
    path = find_in_parent_folders()
}

terraform {
    source = "github.com/terraform-aws-modules/terraform-aws-vpc"
}

inputs = {
  name = "vpc-prod"
  cidr = "10.20.0.0/16"
  azs = ["us-east-2b","us-east-2c"]
  private_subnets = ["10.20.0.0/24","10.20.1.0/24"]
  public_subnets = ["10.20.10.0/24","10.20.11.0/24"]
  enable_nat_gateway = false
}
