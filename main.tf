provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}

data "aws_availability_zones" "available" {}

module "core-network-vpc" {
  # Configure AWS VPC
  source     = "modules/network/vpc/"
  name       = "core-network-vpc"
  cidr_block = "${var.cidr}"
  env        = "${var.env}"
  create_vpc = "${var.create_vpc}"
}

module "core-network-dhcp" {
  # Configure DHCP Option set
  source              = "modules/network/dhcp/"
  name                = "core-network-dhcp"
  env                 = "${var.env}"
  vpc_id              = "${module.core-network-vpc.id}"
  create_vpc          = "${var.create_vpc}"
  enable_dhcp_options = "${var.enable_dhcp_options}"
}

module "public-frontend-subnet-primary" {
  # Configure public subnet 
  source     = "modules/network/subnet/"
  name       = "core-network-vpc-publicsubnet"
  vpc_id     = "${module.core-network-vpc.id}"
  cidr_block = "${var.public-frontend-subnet-primary}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  create_vpc = "${var.create_vpc}"
  env        = "${var.env}"
}

module "public-frontend-subnet-secondary" {
  # Configure secondary public subnet 
  source     = "modules/network/subnet/"
  name       = "core-network-vpc-publicsubnet-secondary"
  vpc_id     = "${module.core-network-vpc.id}"
  cidr_block = "${var.public-frontend-subnet-secondary}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  create_vpc = "${var.create_vpc}"
  env        = "${var.env}"
}

module "private-app-subnet" {
  # Configure public subnet 
  source     = "modules/network/subnet/"
  name       = "core-network-vpc-app-privatesubnet"
  vpc_id     = "${module.core-network-vpc.id}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  cidr_block = "${var.private-app-subnet}"
  create_vpc = "${var.create_vpc}"
  env        = "${var.env}"
}

module "private-db-subnet" {
  # Configure public subnet 
  source     = "modules/network/subnet/"
  name       = "core-network-vpc-db-privatesubnet"
  vpc_id     = "${module.core-network-vpc.id}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  cidr_block = "${var.private-db-subnet}"
  create_vpc = "${var.create_vpc}"
  env        = "${var.env}"
}

module "public-route-table" {
  # Configure Public Route Table
  source     = "modules/network/routetable/"
  name       = "core-network-frontend-routetable"
  vpc_id     = "${module.core-network-vpc.id}"
  env        = "${var.env}"
  type       = "public"                                    # public or private
  create_vpc = "${var.create_vpc}"
}

module "primary-rt-association" {
  source = "modules/network/routetableassociation/"
  create_vpc = "${var.create_vpc}"
  subnet_id = "${module.public-frontend-subnet-primary.subnetid}"
  route_table_id = "${module.public-route-table.rtid}"
}

module "secondary-rt-association" {
  source = "modules/network/routetableassociation/"
  create_vpc = "${var.create_vpc}"
  subnet_id = "${module.public-frontend-subnet-secondary.subnetid}"
  route_table_id = "${module.public-route-table.rtid}"
}

module "app-private-route-table" {
  source     = "modules/network/routetable/"
  name       = "core-network-app-routetable"
  vpc_id     = "${module.core-network-vpc.id}"
  env        = "${var.env}"
  type       = "app-private"
  create_vpc = "${var.create_vpc}"
}

module "db-private-route-table" {
  source     = "modules/network/routetable/"
  name       = "core-network-db-routetable"
  vpc_id     = "${module.core-network-vpc.id}"
  env        = "${var.env}"
  type       = "db-private"
  create_vpc = "${var.create_vpc}"
}

module "app-rt-association" {
  source = "modules/network/routetableassociation/"
  create_vpc = "${var.create_vpc}"
  subnet_id = "${module.private-app-subnet.subnetid}"
  route_table_id = "${module.app-private-route-table.rtid}"
}

module "db-rt-association" {
  source = "modules/network/routetableassociation/"
  create_vpc = "${var.create_vpc}"
  subnet_id = "${module.private-db-subnet.subnetid}"
  route_table_id = "${module.db-private-route-table.rtid}"
}

module "igw" {
  # Configure IGW
  source                 = "modules/network/igw/"
  vpc_id                 = "${module.core-network-vpc.id}"
  env                    = "${var.env}"
  igw_route              = true
  create_vpc             = "${var.create_vpc}"
  route_table_id         = "${module.public-route-table.rtid}"
  destination_cidr_block = "0.0.0.0/0"
}

module "ngweip" {
  source       = "modules/network/eip/"
  create_vpc   = "${var.create_vpc}"
  nat_gw_count = true
  eip          = true
  env          = "natgw"
}

module "ngw" {
  source            = "modules/network/ngw/"
  nat_gateway_route = true
  env               = "${var.env}"
  create_vpc        = "${var.create_vpc}"
  subnet_id         = "${module.public-frontend-subnet-primary.subnetid}"
  allocation_id     = "${module.ngweip.eipalloc}"
}

module "nat-gateway-route-app-subnet" {
  source                 = "modules/network/routes/"
  route_table_id         = "${module.app-private-route-table.rtid}"
  destination_cidr_block = "0.0.0.0/0"
  create_vpc             = "${var.create_vpc}"
  nat_gateway_route      = true
  nat_gateway_id         = "${module.ngw.ngw}"
}

module "nat-gateway-route-db-subnet" {
  source                 = "modules/network/routes/"
  route_table_id         = "${module.db-private-route-table.rtid}"
  destination_cidr_block = "0.0.0.0/0"
  create_vpc             = "${var.create_vpc}"
  nat_gateway_route      = true
  nat_gateway_id         = "${module.ngw.ngw}"
}

module "public-lb" {
  source = "modules/compute/elb/"
  availability_zones = ["${data.aws_availability_zones.available.names[0]}", "${data.aws_availability_zones.available.names[1]}"]
  subnets = ["${module.public-frontend-subnet-primary.subnetid}", "${module.public-frontend-subnet-secondary.subnetid}"]
  cross_zone_load_balancing = "false"
  elb_name = "public-lb"
  env = "${var.env}"
}