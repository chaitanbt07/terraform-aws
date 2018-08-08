output "rtid" {
    value = "${aws_route_table.rt.*.id}"
}

output "rtassociatonid" {
    value = "${aws_route_table_association.rtassociaton.id}"
}