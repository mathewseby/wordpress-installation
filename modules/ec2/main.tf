resource "aws_instance" "wp" {
  name = var.name
  ami                    = var.instance_ami
  key_name               = var.instance_key_name
  subnet_id              = var.subnet
  instance_type          = var.resource_type
  vpc_security_group_ids = var.security_group_ids
  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }
}

resource "aws_route53_zone" "private" {
  name = var.internal_domain
  vpc {
    vpc_id = var.vpc_id
  }
}

resource "aws_route53_record" "server_dns" {
  name    = aws_instance.wp.name
  type    = "A"
  zone_id = aws_route53_zone.private.zone_id
  ttl = "300"
  records = aws_instance.wp.private_ip
}