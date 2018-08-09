output "subnetid" {
  value = "${element(concat(aws_subnet.subnet.*.id, list("")), 0)}"
}

output "subnet-az" {
  value = "${element(concat(aws_subnet.subnet.*.availability_zone, list("")), 0)}"
}

output "subnet-cidr" {
  value = "${element(concat(aws_subnet.subnet.*.cidr_block, list("")), 0)}"
}
