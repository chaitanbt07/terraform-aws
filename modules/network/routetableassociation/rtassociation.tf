# Configure Route Table Association
resource "aws_route_table_association" "rtassociaton" {
  count          = "${var.create_vpc ? 1 :0}"
  subnet_id      = "${var.subnet_id}"
  #route_table_id = "${element(aws_route_table.rt.*.id, count.index)}"
  route_table_id = "${var.route_table_id}"
}