variable "name" {}
variable "env" {}
variable "vpc_id" {
    type = "list"
}
variable "create_vpc" {}
variable "enable_dhcp_options" {}