variable "name" {
  default = ""
}

variable "subnet_count" {}

variable "vpc_id" {}

variable "cidr_block" {
  type = "list"
}

variable "env" {
  default = ""
}

variable "create_vpc" {
  default = ""
}

variable "availability_zone" {
  type = "list"
}