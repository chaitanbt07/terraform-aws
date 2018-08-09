output "eipalloc" {
  value = "${element(concat(aws_eip.eip.*.id, list("")), 0)}"
}

output "eipprivateip" {
  value = "${element(concat(aws_eip.eip.*.private_ip, list("")), 0)}"
}

output "eip" {
  value = "${element(concat(aws_eip.eip.*.public_ip, list("")), 0)}"
}
