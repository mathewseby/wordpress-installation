resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "for aws instance"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "ec2-ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.ec2_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ec2-httpd" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.ec2_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ec2-out" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.ec2_sg.id
  cidr_blocks       = ["0.0.0.0/0"]

}

resource "aws_security_group_rule" "ec2-out-https" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.ec2_sg.id
  cidr_blocks       = ["0.0.0.0/0"]

}

resource "aws_security_group" "db-sg" {
  count       = var.install_type == "server_with_rds" || var.install_type == "with_docker_rds" || var.install_type == "eks" ? 1 : 0
  name        = "db_sg"
  description = "for database instance"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "ec2-db-outbound" {
  count                    = var.install_type == "server_with_rds" || var.install_type == "with_docker_rds" || var.install_type == "eks" ? 1 : 0
  type                     = "egress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2_sg.id
  source_security_group_id = one(aws_security_group.db-sg[*].id)
}

resource "aws_security_group_rule" "db-inbound" {
  count                    = var.install_type == "server_with_rds" || var.install_type == "with_docker_rds" || var.install_type == "eks" ? 1 : 0
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = one(aws_security_group.db-sg[*].id)
  source_security_group_id = aws_security_group.ec2_sg.id
}

resource "aws_security_group_rule" "db-inbound-eks" {
  count                    = var.install_type == "server_with_rds" || var.install_type == "with_docker_rds" || var.install_type == "eks" ? 1 : 0
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = one(aws_security_group.db-sg[*].id)
  source_security_group_id = one(aws_security_group.eks-sg[*].id)

}

resource "aws_security_group" "eks-sg" {
  count       = var.install_type == "eks" ? 1 : 0
  name        = "ecs-sg"
  description = "for ecs"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "eks-inbound-http" {
  count             = var.install_type == "eks" ? 1 : 0
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = one(aws_security_group.eks-sg[*].id)
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "eks-inbound-https" {
  count             = var.install_type == "eks" ? 1 : 0
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = one(aws_security_group.eks-sg[*].id)
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "eks-out" {
  count             = var.install_type == "eks" ? 1 : 0
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = one(aws_security_group.eks-sg[*].id)
  cidr_blocks       = ["0.0.0.0/0"]

}

resource "aws_security_group_rule" "eks-out-https" {
  count             = var.install_type == "eks" ? 1 : 0
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = one(aws_security_group.eks-sg[*].id)
  cidr_blocks       = ["0.0.0.0/0"]

}

resource "aws_security_group_rule" "eks-db-outbound" {
  count                    = var.install_type == "eks" ? 1 : 0
  type                     = "egress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = one(aws_security_group.eks-sg[*].id)
  source_security_group_id = one(aws_security_group.db-sg[*].id)
}