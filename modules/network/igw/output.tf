output "igwid" {
  value = "${element(concat(aws_internet_gateway.igw.*.id, list("")), 0)}"
}
