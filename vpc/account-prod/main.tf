provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source = "../../"

  name = "prod-example"

  cidr = "10.10.0.0/16"

  azs                 = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  public_subnets      = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]

  create_database_subnet_group = false

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_vpn_gateway = false

  enable_s3_endpoint       = true
  enable_dynamodb_endpoint = true

  enable_dhcp_options              = true
  dhcp_options_domain_name         = "arunsingh.co"
  dhcp_options_domain_name_servers = ["127.0.0.1", "10.10.0.2"]

  tags = {
    Owner       = "user"
    Environment = "staging"
    Name        = "complete"
  }
}