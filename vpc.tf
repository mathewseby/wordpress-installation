resource "aws_vpc" "vpc" {
  cidr_block = "172.20.0.0/16"
}

resource "aws_subnet" "ec2-01" {
  cidr_block              = "172.20.1.0/24"
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
}

resource "aws_subnet" "eks-01" {
  count                   = var.install_type == "eks" ? 1 : 0
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  cidr_block              = "172.20.4.0/24"
  vpc_id                  = aws_vpc.vpc.id
}

resource "aws_subnet" "eks-02" {
  count                   = var.install_type == "eks" ? 1 : 0
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
  cidr_block              = "172.20.5.0/24"
  vpc_id                  = aws_vpc.vpc.id
}

resource "aws_subnet" "db-01" {
  count             = var.install_type == "server_with_rds" || var.install_type == "with_docker_rds" || var.install_type == "ecs" || var.install_type == "eks" ? 1 : 0
  cidr_block        = "172.20.6.0/24"
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "ap-south-1a"
}

resource "aws_subnet" "db-02" {
  count             = var.install_type == "server_with_rds" || var.install_type == "with_docker_rds" || var.install_type == "ecs" || var.install_type == "eks" ? 1 : 0
  cidr_block        = "172.20.7.0/24"
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "ap-south-1c"
}

resource "aws_subnet" "lb-01" {
  count             = var.install_type == "ecs" ? 1 : 0
  cidr_block        = "172.20.8.0/24"
  availability_zone = "ap-south-1a"
  vpc_id            = aws_vpc.vpc.id
}

resource "aws_subnet" "lb-02" {
  count             = var.install_type == "ecs" ? 1 : 0
  cidr_block        = "172.20.9.0/24"
  availability_zone = "ap-south-1b"
  vpc_id            = aws_vpc.vpc.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "private" {
  count  = var.install_type == "server_with_rds" || var.install_type == "with_docker_rds" || var.install_type == "ecs" ? 1 : 0
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "igw-assoc" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public-01" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.ec2-01.id

}

resource "aws_route_table_association" "public-02" {
  count          = var.install_type == "ecs" ? 1 : 0
  route_table_id = aws_route_table.public.id
  subnet_id      = one(aws_subnet.lb-01[*].id)

}

resource "aws_route_table_association" "public-03" {
  count          = var.install_type == "ecs" ? 1 : 0
  route_table_id = aws_route_table.public.id
  subnet_id      = one(aws_subnet.lb-02[*].id)

}

resource "aws_route_table_association" "public-06" {
  count          = var.install_type == "eks" ? 1 : 0
  route_table_id = one(aws_route_table.public[*].id)
  subnet_id      = one(aws_subnet.eks-01[*].id)
}

resource "aws_route_table_association" "public-07" {
  count          = var.install_type == "eks" ? 1 : 0
  route_table_id = one(aws_route_table.public[*].id)
  subnet_id      = one(aws_subnet.eks-02[*].id)
}

resource "aws_route_table_association" "private-01" {
  count          = var.install_type == "server_with_rds" || var.install_type == "with_docker_rds" || var.install_type == "ecs" ? 1 : 0
  route_table_id = one(aws_route_table.private[*].id)
  subnet_id      = one(aws_subnet.db-01[*].id)

}

resource "aws_route_table_association" "private-02" {
  count          = var.install_type == "server_with_rds" || var.install_type == "with_docker_rds" || var.install_type == "ecs" ? 1 : 0
  route_table_id = one(aws_route_table.private[*].id)
  subnet_id      = one(aws_subnet.db-02[*].id)
}

resource "aws_db_subnet_group" "db" {
  count      = var.install_type == "server_with_rds" || var.install_type == "with_docker_rds" || var.install_type == "eks" ? 1 : 0
  subnet_ids = [one(aws_subnet.db-02[*].id), one(aws_subnet.db-01[*].id)]
}
