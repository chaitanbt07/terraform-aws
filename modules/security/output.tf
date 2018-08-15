output "roleid" {
    value = "${data.aws_iam_role.iamrole.id}"
}

output "rolearn" {
    value = "${data.aws_iam_role.iamrole.arn}"
}

output "rolepath" {
    value = "${data.aws_iam_role.iamrole.path}"
}
