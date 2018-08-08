resource "aws_subnet" "subnet" {
  count = "${var.create_vpc ? 1 : 0}"
  vpc_id     = "${var.vpc_id[count.index]}"
  cidr_block = "${var.cidr_block}"

  tags {
    Name = "${var.name}"
    env = "${var.env}"
  }
}