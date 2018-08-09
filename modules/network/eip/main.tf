resource "aws_eip" "eip" {
  count = "${var.create_vpc && (var.nat_gw_count || var.eip) ? 1 : 0}"
  vpc   = true

  tags {
    Name = "${var.env}-eip-0${count.index + 1}"
  }
}
