resource "aws_vpc_dhcp_options" "dhcpoptionset" {
  count = "${var.create_vpc && var.enable_dhcp_options ? 1 : 0}"
  domain_name          = "poc.local"
  domain_name_servers  = ["127.0.0.1", "10.0.0.2"]
  ntp_servers          = ["127.0.0.1"]
  netbios_name_servers = ["127.0.0.1"]
  netbios_node_type    = 2

  tags {
    Name = "${var.name}-0${count.index + 1}"
    env = "${var.env}"
  }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  count = "${var.create_vpc && var.enable_dhcp_options ? 1 : 0}"
  vpc_id          = "${var.vpc_id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.dhcpoptionset.id}"
}