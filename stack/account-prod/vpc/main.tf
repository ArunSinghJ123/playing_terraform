provider "aws" {
  region = "us-west-2"
}

module "vpc" "east"{
  source = "../../../"

  name = "prod-example-1"

  cidr = "${var.cidr}"

  azs                 = "${var.azs}"
  private_subnets     = "${var.private_subnets}"
  public_subnets      = "${var.public_subnets}"
  create_database_subnet_group = true
  enable_nat_gateway = true
  single_nat_gateway = true
  enable_s3_endpoint       = true
  enable_dynamodb_endpoint = false
  enable_dhcp_options              = true
  enable_dns_support               = true
  enable_dns_hostnames             = true
  dhcp_options_domain_name         = "${var.privatehostedzone}"
  dhcp_options_domain_name_servers = ["127.0.0.1", "10.10.0.2"]
  enable_vpn_gateway = true
  propagate_private_route_tables_vgw = true
  tags = {
    Owner       = "Arun"
    Environment = "staging"
    Name        = "RouteVPC-Prod-Components"
  }
}

module "urvpc" "east"{
  source = "../../../"

  name = "prod-example-2"

  cidr = "${var.ur_cidr}"

  azs                 = "${var.azs}"
  private_subnets     = "${var.ur_private_subnets}"
  public_subnets      = "${var.ur_public_subnets}"

  create_database_subnet_group = true

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_vpn_gateway = false

  enable_s3_endpoint       = true
  enable_dynamodb_endpoint = false

  enable_dhcp_options              = true
  enable_dns_support               = true
  enable_dns_hostnames             = true
  dhcp_options_domain_name         = "${var.privatehostedzone}"
  dhcp_options_domain_name_servers = ["127.0.0.1", "172.16.0.2"]

  tags = {
    Owner       = "user"
    Environment = "staging"
    Name        = "UnrouteVPC-Prod-Components"
  }
}

data "aws_caller_identity" "current" { }

resource "aws_vpc_peering_connection" "here" {
  peer_owner_id = "${data.aws_caller_identity.current.account_id}"
  peer_vpc_id   = "${module.urvpc.vpc_id}"
  vpc_id        = "${module.vpc.vpc_id}"
  auto_accept   = true
}

##### COLLECTING LOCALS FOR THE CASCADE  ##########

locals{
    nof_private_subnets = "${length(var.private_subnets)}"
    ur_nof_private_subnets = "${length(var.ur_private_subnets)}"

}

locals{
  route_private_route_table_ids =  ["${module.vpc.private_route_table_ids}"]

}

locals{
  unroute_private_route_table_ids =  ["${module.urvpc.private_route_table_ids}"]

}

locals {
  vpc_cidr         = ["${module.vpc.vpc_cidr_block}", "${module.urvpc.vpc_cidr_block}"]
}

locals {
  vpc_cidr_block   = "${module.vpc.vpc_cidr_block}"
}

locals {
  urvpc_cidr_block   = "${module.urvpc.vpc_cidr_block}"
}


locals {
  vpc_id         = "${module.vpc.vpc_id}"
}

locals {
  urvpc_id         = "${module.urvpc.vpc_id}"
}

locals {
  name_prefix         = ["${module.vpc.vpc_id}", "${module.urvpc.vpc_id}"]
}



  ############################
  # VPC PEERING ROUTES
  ############################

resource "aws_route" "peering" {
  count = "${var.create_peering ? 1 : 0}"
  route_table_id         = "${element(concat(local.route_private_route_table_ids, list("")), count.index)}"
  destination_cidr_block = "${local.urvpc_cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.here.id}"
  timeouts {
    create = "5m"
  }
}

resource "aws_route" "ur_peering" {
  count = "${var.create_peering ? 1 : 0}"
  route_table_id         = "${element(concat(local.unroute_private_route_table_ids, list("")), count.index)}"
  destination_cidr_block = "${local.vpc_cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.here.id}"
  timeouts {
    create = "5m"
  }
}

# CREATION OF THE SECURITY GROUPS

module "aws_security_group" "route" {
  source     = "../security-groups/"
  create_routable_app_sg = true
  vpc_id = "${local.vpc_id}"
  vpc_cidr_block = "${local.vpc_cidr_block}"
  urvpc_cidr_block = "${local.urvpc_cidr_block}"
}

# CREATION OF THE PRIVATE AND PUBLIC HZ'S
module "aws_route53_zone" "split" {
  source     = "../hosted-zone/"
  create_publiczone = true
  create_privatezone = true
  publichostedzone = "${var.publichostedzone}"
  privatehostedzone  = "${var.privatehostedzone}"
  vpc_id = "${local.vpc_id}"
  urvpc_id = "${local.urvpc_id}"
}
