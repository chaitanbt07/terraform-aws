resource "aws_route_table" "rt" {
    count = "${var.create_vpc ? 1 :0}"
    vpc_id = ["${var.vpc_id}"]
    tags {
    Name = "${var.env}-rt0${count.index + 1}"
  }
}