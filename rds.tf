resource "aws_db_instance" "wp-rds" {
  count                = var.install_type == "server_with_rds" || var.install_type == "with_docker_rds" ? 1 : 0
  identifier           = "wpdb"
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  name                 = "wpdatabase"
  username             = "root"
  password             = var.mysql_root_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  vpc_security_group_ids = [
    "${one(aws_security_group.db_sg[*].id)}"
  ]
  db_subnet_group_name = one(aws_db_subnet_group.db[*].id)
}

output "rds-output" {
  value = one(aws_db_instance.wp-rds[*].endpoint)
}