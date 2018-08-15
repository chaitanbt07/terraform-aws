data "aws_iam_role" "iamrole" {
  name = "${var.role_name}"
}