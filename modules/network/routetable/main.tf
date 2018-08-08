resource "aws_route_table" "rt" {
    count = "${var.create_vpc ? 1 :0}"
    vpc_id = "${var.vpc_id}"
    tags {
    Name = "${var.env}-${var.type}-rt0${count.index + 1}"
  }
}

# Configure Route Table Association
resource "aws_route_table_association" "rtassociaton" {
  count = "${var.create_vpc ? 1 :0}"
  subnet_id = "${var.subnet_id}"
  route_table_id = "${element(aws_route_table.rt.*.id, count.index)}"
}