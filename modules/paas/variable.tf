variable "solution_stack_name" {
    default = "64bit Amazon Linux 2018.03 v2.7.2 running Python 3.6"
}

variable "tier" {
  default     = "WebServer"
  description = "Elastic Beanstalk Environment tier, e.g. ('WebServer', 'Worker')"
}

variable "env" {}

variable "appname" {}

variable "description" {
    default = "sample applicitoion"
}

variable "version_label" {
  default     = ""
  description = "Elastic Beanstalk Application version for deploy"
}

variable "vpcid" {}

variable "public_subnet" {}

variable "service_role" {}

variable "associate_public_ip_address" {
    default = "true"
}

variable "iam_instance-profile" {
    default = "aws-elasticbeanstalk-ec2-role"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "min_size" {
    default = 1
}

variable "max_size" {
    default = 3
}
