output "id" {
    value = "${element(concat(aws_vpc.core-network.*.id, list("")), count.index)}"
}

output "vpcarn" {
    value = "${element(concat(aws_vpc.core-network.*.arn, list("")), count.index)}"
}

output "vpc-cidr" {
    value = "${element(concat(aws_vpc.core-network.*.cidr_block, list("")), count.index)}"
}

output "main-rt" {
    value = "${element(concat(aws_vpc.core-network.*.main_route_table_id, list("")), count.index)}"
}

output "default-nacl" {
    value = "${element(concat(aws_vpc.core-network.*.default_network_acl_id, list("")), count.index)}"
}

output "default-sg" {
    value = "${element(concat(aws_vpc.core-network.*.default_security_group_id, list("")), count.index)}"
}

output "default-rt" {
    value = "${element(concat(aws_vpc.core-network.*.default_route_table_id, list("")), count.index)}"
}