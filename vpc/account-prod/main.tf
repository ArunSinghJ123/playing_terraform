provider "aws" {
  region = "us-west-2"
}

module "vpc" "east"{
  source = "../../"

  name = "prod-example-1"

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
  enable_dns_support               = true
  enable_dns_hostnames             = true
  dhcp_options_domain_name         = "arunsinghjeya.co"
  dhcp_options_domain_name_servers = ["127.0.0.1", "10.10.0.2"]
  tags = {
    Owner       = "Arun"
    Environment = "staging"
    Name        = "Unroutable-VPC"
  }
}

module "urvpc" "east"{
  source = "../../"

  name = "prod-example-2"

  cidr = "172.16.0.0/16"

  azs                 = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets     = ["172.16.0.0/24", "172.16.1.0/24", "172.16.2.0/24"]
  public_subnets      = ["172.16.3.0/24", "172.16.4.0/24", "172.16.5.0/24"]

  create_database_subnet_group = false

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_vpn_gateway = false

  enable_s3_endpoint       = true
  enable_dynamodb_endpoint = true

  enable_dhcp_options              = true
  enable_dns_support               = true
  enable_dns_hostnames             = true
  dhcp_options_domain_name         = "arunsinghjeya.co"
  dhcp_options_domain_name_servers = ["127.0.0.1", "172.16.0.2"]

  tags = {
    Owner       = "user"
    Environment = "staging"
    Name        = "Unroutable-VPC"
  }
}

data "aws_caller_identity" "current" { }

resource "aws_vpc_peering_connection" "foo" {
  peer_owner_id = "${data.aws_caller_identity.current.account_id}"
  peer_vpc_id   = "${module.urvpc.vpc_id}"
  vpc_id        = "${module.vpc.vpc_id}"
  auto_accept   = true
}

locals {
  vpc_cidr         = ["${module.vpc.vpc_cidr_block}", "${module.urvpc.vpc_cidr_block}"]
}

locals {
  name_prefix         = ["${module.vpc.vpc_id}", "${module.urvpc.vpc_id}"]
}

# CREATION OF THE SECURITY GROUPS

resource "aws_security_group" "http" {
  count       = 2
  name        = "HTTPfromOut"
  description = "Allow all HTTP traffic"
  vpc_id      = "${element(local.name_prefix, count.index)}"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${module.vpc.vpc_cidr_block}", "${module.urvpc.vpc_cidr_block}"]
  }

  tags = {
    Name = "HTTPfromOut"
  }
}

resource "aws_security_group" "app" {
  count       = 2
  name        = "AppfromOut"
  description = "Allow all App traffic"
  vpc_id      = "${element(local.name_prefix, count.index)}"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${module.vpc.vpc_cidr_block}", "${module.urvpc.vpc_cidr_block}"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${module.vpc.vpc_cidr_block}", "${module.urvpc.vpc_cidr_block}"]
  }

  tags = {
    Name = "AppfromOut"
  }
}


# CREATION OF THE PRIVATE AND PUBLIC HZ'S

resource "aws_route53_zone" "public" {
  name = "arunsinghjeya.co"
}

resource "aws_route53_zone" "private" {
  name = "arunsinghjeya.co"

  vpc {
    vpc_id = "${module.vpc.vpc_id}"
  }

  lifecycle {
    ignore_changes = ["vpc"]
  }
}


resource "aws_route53_zone_association" "unroute" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  vpc_id  = "${module.urvpc.vpc_id}"
}
