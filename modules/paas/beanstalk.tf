resource "aws_elastic_beanstalk_application" "beanstalkapp" {
  name        = "${var.env}${var.appname}"
  description = "${var.description}"

  appversion_lifecycle {
    service_role          = "${var.service_role}"
    max_count             = 128
    delete_source_from_s3 = true
  }
}

resource "aws_elastic_beanstalk_environment" "beanstalkenv" {
  name                = "${var.appname}-env"
  application         = "${aws_elastic_beanstalk_application.beanstalkapp.name}"
  cname_prefix = "${var.appname}"
  tier = "${var.tier}"
  #version_label = "${var.version_label}"
  solution_stack_name = "${var.solution_stack_name}"
  wait_for_ready_timeout = "20m"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "IamInstanceProfile"
    value = "${var.iam_instance-profile}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "InstanceType"
    value = "${var.instance_type}"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name = "Availability Zones"
    value = "Any 2"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name = "MinSize"
    value = "${var.min_size}"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name = "MaxSize"
    value = "${var.max_size}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name = "EnvironmentType"
    value = "SingleInstance"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = "${var.service_role}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${var.vpcid}"
  }
  
  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "${var.associate_public_ip_address}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${var.public_subnet}"
  }

tags {
      env = "${var.env}"
      Name = "${var.env}${var.appname}"
  }
}