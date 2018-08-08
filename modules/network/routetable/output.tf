output "rtid" {
    value = "${element(concat(aws_route_table.rt.*.id, list("")), 0)}"
}

output "rtassociatonid" {
    value = "${aws_route_table_association.rtassociaton.id}"
}