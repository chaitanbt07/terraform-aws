resource "aws_internet_gateway" "igw" {
  count = "${var.create_vpc ? 1 : 0}"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.env}-igw-0${count.index + 1}"
    env = "${var.env}"
  }
}