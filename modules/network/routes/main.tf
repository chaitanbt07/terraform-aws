resource "aws_route" "route" {
    count = "${var.create_vpc && var.nat_gateway_route ? 1 : 0}"
    route_table_id = "${var.route_table_id}"
    destination_cidr_block = "${var.destination_cidr_block}"
    gateway_id = "${var.gateway_route ? var.gateway_id : "null"}"
    nat_gateway_id = "${var.nat_gateway_route ? var.nat_gateway_id : "null"}"
}