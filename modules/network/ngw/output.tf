output "ngw" {
  value = "${element(concat(aws_nat_gateway.ngw.*.id, list("")), 0)}"
}

/*output "ngwsubnet" {
    value = "${aws_nat_gateway.ngw.*.subnet_id}"
}*/

output "ngwnetwork_interface_id" {
  value = "${aws_nat_gateway.ngw.*.network_interface_id}"
}

output "ngwprivate_ip" {
  value = "${aws_nat_gateway.ngw.*.private_ip}"
}

output "ngwpublic_ip" {
  value = "${aws_nat_gateway.ngw.*.public_ip}"
}
