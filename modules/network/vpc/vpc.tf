resource "aws_vpc" "core-network" {
  count = "${var.create_vpc ? 1 : 0}"
  cidr_block = "${var.cidr_block[count.index]}"
  enable_dns_support = "True"
  enable_dns_hostnames = "True"
  tags {
    Name = "${var.name}-0${count.index + 1}"
    env  = "${var.env}"
  }
}