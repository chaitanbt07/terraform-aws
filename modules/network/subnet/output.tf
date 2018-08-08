output "subnetid" {
    value = "${aws_subnet.subnet.*.id}"
}

output "subnet-az" {
    value = "${aws_subnet.subnet.*.availability_zone}"
}

output "subnet-cidr" {
    value = "${aws_subnet.subnet.*.cidr_block}"
}
