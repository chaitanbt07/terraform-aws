variable "route_table_id" {}
variable "destination_cidr_block" {}
variable "nat_gateway_id" {
    default = "false"
}
variable "gateway_id" {
    default = "false"
}
