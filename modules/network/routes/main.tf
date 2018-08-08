resource "aws_route" "route" {
    route_table_id = "${var.route_table_id}"
    destination_cidr_block = "${var.destination_cidr_block}"
    gateway_id = "${var.gateway_id != "false" ? var.gateway_id : false}" # Either IGW or VPW
    nat_gateway_id = "${var.nat_gateway_id != "false" ? var.nat_gateway_id : false}"
}