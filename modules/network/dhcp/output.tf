output "dhcpopid" {
  value = "${aws_vpc_dhcp_options.dhcpoptionset.*.id}"
}

output "dhcpopassoid" {
  value = "${aws_vpc_dhcp_options_association.dns_resolver.*.id}"
}
