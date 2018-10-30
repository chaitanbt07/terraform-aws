resource "aws_db_subnet_group" "dbsubnetgrp" {
  name       = "dbsubnetgrp"
  subnet_ids = ["${var.subnet_ids}"]

  tags {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "rds" {
  allocated_storage    = 10
  apply_immediately = "false"
  auto_minor_version_upgrade = "true"
  db_subnet_group_name = 
  deletion_protection = "false"
  enabled_cloudwatch_logs_exports = ["alert", "audit", "error", "general", "listener", "slowquery", "trace"]
  engine               = "mysql"
  engine_version       = "5.7"
  identifier_prefix = "sampledb"
  multi_az = "true"
  copy_tags_to_snapshot = "true"
  storage_type         = "gp2"
  instance_class       = "db.t2.micro"
  publicly_accessible = "false"
  skip_final_snapshot = "true"
  name                 = "sampledb"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
}