/*resource "aws_eip" "natgweip" {
  count = "${var.create_vpc ? 1 : 0}"
  vpc = true
  #depends_on                = ["${var.internet_gateway}"]
  tags {
      Name = "${var.env}-natgweip"
  }
}*/

resource "aws_nat_gateway" "ngw" {
  count         = "${var.create_vpc ? 1 : 0}"
  allocation_id = "${var.allocation_id}"
  subnet_id     = "${var.subnet_id}"          # Public subnet id

  tags {
    Name = "${var.env}-ngw"
  }
}

/*resource "aws_route" "ngwroute" {
    count = "${var.create_vpc ? 1 : 0}"
    route_table_id = "${var.route_table_id[count.index]}" # Private route table id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.ngw.*.id, count.index}"
    depends_on = ["aws_nat_gateway.ngw"]
}*/

