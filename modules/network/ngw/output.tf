output "ngweipalloc" {
    value = "${aws_eip.natgweip.id}"
}

output "ngweipprivateip" {
    value = "${aws_eip.natgweip.private_ip }"
}

output "ngweip" {
    value = "${aws_eip.natgweip.public_ip}"
}

output "ngw" {
    value = "${aws_nat_gateway.ngw.id}"
}

output "ngwsubnet" {
    value = "${aws_nat_gateway.ngw.subnet_id}"
}

output "ngwnetwork_interface_id" {
    value = "${aws_nat_gateway.ngw.network_interface_id}"
}

output "ngwprivate_ip" {
    value = "${aws_nat_gateway.ngw.private_ip}"
}

output "ngwpublic_ip" {
    value = "${aws_nat_gateway.ngw.public_ip}"
}