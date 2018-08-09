resource "aws_internet_gateway" "igw" {
  count = "${var.create_vpc ? 1 : 0}"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.env}-igw-0${count.index + 1}"
    env = "${var.env}"
  }
}

resource "aws_route" "igwroute" {
    route_table_id = "${var.route_table_id}"
    destination_cidr_block = "${var.destination_cidr_block}"
    gateway_id = "${aws_internet_gateway.igw.id}"
    depends_on = ["aws_internet_gateway.igw"]
}