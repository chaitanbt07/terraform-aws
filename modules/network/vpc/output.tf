output "id" {
  value = "${element(concat(aws_vpc.core-network.*.id, list("")), 0)}"
}

output "vpcarn" {
  value = "${element(concat(aws_vpc.core-network.*.arn, list("")), 0)}"
}

output "vpc-cidr" {
  value = "${element(concat(aws_vpc.core-network.*.cidr_block, list("")), 0)}"
}

output "main-rt" {
  value = "${element(concat(aws_vpc.core-network.*.main_route_table_id, list("")), 0)}"
}

output "default-nacl" {
  value = "${element(concat(aws_vpc.core-network.*.default_network_acl_id, list("")), 0)}"
}

output "default-sg" {
  value = "${element(concat(aws_vpc.core-network.*.default_security_group_id, list("")), 0)}"
}

output "default-rt" {
  value = "${element(concat(aws_vpc.core-network.*.default_route_table_id, list("")), 0)}"
}
