resource "aws_eip" "natgweip" {
  vpc = true
  #depends_on                = ["${var.internet_gateway}"]
  tags {
      Name = "${var.env}-natgweip"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = "${aws_eip.natgweip.id}"
  subnet_id     = "${var.subnet_id}" # Public subnet id

  tags {
    Name = "${var.env}-ngw"
  }
}

locals {
    route_count = "${length(var.route_table_id)}"
}

resource "aws_route" "ngwroute" {
    count = "${var.create_vpc && (local.route_count > 0) ? local.route_count : 0}"
    route_table_id = "${var.route_table_id[count.index]}" # Private route table id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.ngw.id}"
    depends_on = ["aws_nat_gateway.ngw"]
}