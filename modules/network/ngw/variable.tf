variable "internet_gateway" {}

variable "env" {}

variable "subnet_id" {
    description = "The Public Subnet ID"
    default = ""
}

variable "route_table_id" {
    description = "The Private route table"
    default = ""
}
