resource "aws_vpc" "vpc" {
  cidr_block = "172.20.0.0/16"
}

resource "aws_subnet" "ec2-01" {
  cidr_block              = "172.20.1.0/24"
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
}

resource "aws_subnet" "db-01" {
  cidr_block        = "172.20.2.0/24"
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "ap-south-1a"
}

resource "aws_subnet" "db-02" {
  cidr_block        = "172.20.3.0/24"
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "ap-south-1c"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "igw-assoc" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.ec2-01.id

}

resource "aws_route_table_association" "private-01" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.db-01.id

}

resource "aws_route_table_association" "private-02" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.db-02.id
}

resource "aws_db_subnet_group" "db" {
  subnet_ids = [aws_subnet.db-02.id, aws_subnet.db-01.id]
}

resource "aws_subnet" "eks-01" {
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  cidr_block              = "172.20.4.0/24"
  vpc_id                  = aws_vpc.vpc.id
}

resource "aws_subnet" "eks-02" {
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
  cidr_block              = "172.20.5.0/24"
  vpc_id                  = aws_vpc.vpc.id
}

resource "aws_subnet" "eks-03" {
  cidr_block              = "172.20.6.0/24"
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"
}

resource "aws_subnet" "eks-04" {
  cidr_block              = "172.20.7.0/24"
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1b"
}

resource "aws_route_table_association" "public-06" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.eks-01.id
}

resource "aws_route_table_association" "public-07" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.eks-02.id
}

resource "aws_route_table_association" "public-08" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.eks-03.id
}

resource "aws_route_table_association" "public-09" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.eks-04.id
}