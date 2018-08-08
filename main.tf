/*module "provider" {
  # Configure the AWS Provider
  source       = "modules/provider"
  access_key   = "${var.aws_access_key}"
  secret_key   = "${var.aws_secret_key}"
  region       = "${var.region}"
}*/

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

module "core-network-vpc" {
  # Configure AWS VPC
  source     = "modules/network/vpc/"
  name = "core-network-vpc"
  cidr_block = "${var.cidr}"
  env          = "${var.env}"
  create_vpc = "${var.create_vpc}"
}

module "core-network-dhcp" {
  # Configure DHCP Option set
  source = "modules/network/dhcp/"
  name = "core-network-dhcp"
  env          = "${var.env}"
  vpc_id = "${module.core-network-vpc.id}"
  create_vpc = "${var.create_vpc}"
  enable_dhcp_options = "${var.enable_dhcp_options}"
}

module "public-frontend-subnet" {
  # Configure public subnet 
  source = "modules/network/"
  name = "core-network-vpc-publicsubnet"
  vpc_id = "${module.core-network-vpc.id}"
  cidr_block = "${var.public-frontend-subnet}"
  create_vpc = "${var.create_vpc}"
  env = "${var.env}"
}

module "private-app-subnet" {
  # Configure public subnet 
  source = "modules/network/"
  name = "core-network-vpc-app-privatesubnet"
  vpc_id = "${module.core-network-vpc.id}"
  cidr_block = "${var.private-app-subnet}"
  create_vpc = "${var.create_vpc}"
  env = "${var.env}"
}

module "private-db-subnet" {
  # Configure public subnet 
  source = "modules/network/"
  name = "core-network-vpc-db-privatesubnet"
  vpc_id = "${module.core-network-vpc.id}"
  cidr_block = "${var.private-db-subnet}"
  create_vpc = "${var.create_vpc}"
  env = "${var.env}"
}

/*module "public-route-table" {
  # Configure Public Route Table
  source = "modules/network/routetable/"
  name = "core-network-frontend-routetable"
  vpc_id = "${module.core-network-vpc.id}"


}*/