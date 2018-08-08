output "id" {
    value = "${aws_vpc.core-network.*.id}"
}

output "vpcarn" {
    value = "${aws_vpc.core-network.*.arn}"
}

output "vpc-cidr" {
    value = "${aws_vpc.core-network.*.cidr_block}"
}

output "main-rt" {
    value = "${aws_vpc.core-network.*.main_route_table_id}"
}

output "default-nacl" {
    value = "${aws_vpc.core-network.*.default_network_acl_id}"
}

output "default-sg" {
    value = "${aws_vpc.core-network.*.default_security_group_id}"
}

output "default-rt" {
    value = "${aws_vpc.core-network.*.default_route_table_id}"
}