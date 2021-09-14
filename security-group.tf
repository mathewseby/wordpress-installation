resource "aws_security_group" "ec2_sg" {
  name = "ec2-sg"
  description = "for aws instance"
  vpc_id = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "ec2-ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id = aws_security_group.ec2_sg.id
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ec2-httpd" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  security_group_id = aws_security_group.ec2_sg.id
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ec2-out" {
  type = "egress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  security_group_id = aws_security_group.ec2_sg.id
  cidr_blocks = ["0.0.0.0/0"]

}

resource "aws_security_group_rule" "ec2-out-https" {
  type = "egress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  security_group_id = aws_security_group.ec2_sg.id
  cidr_blocks = ["0.0.0.0/0"]

}

