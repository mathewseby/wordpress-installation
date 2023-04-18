resource "aws_instance" "wp" {
  ami                    = "var.instance-ami"
  key_name               = "var.instance_key_name"
  subnet_id              = "var.ec2-01"
  instance_type          = "var.resource_type"
  vpc_security_group_ids = var.security_group_ids
  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }
}
