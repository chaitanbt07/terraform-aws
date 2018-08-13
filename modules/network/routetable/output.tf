output "rtid" {
  value = "${element(concat(aws_route_table.rt.*.id, list("")), 0)}"
}
