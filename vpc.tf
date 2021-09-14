provider "aws" {
 region = "us-east-1"
}
resource "aws_vpc" "vpc" {
 cidr_block = "172.20.0.0/16"
}

resource "aws_subnet" "ec2-01" {
 cidr_block = "172.20.1.0/24"
 vpc_id = aws_vpc.vpc.id
 map_public_ip_on_launch = true
}

resource "aws_subnet" "ec2-02" {
 cidr_block = "172.20.2.0/24"
 vpc_id = aws_vpc.vpc.id
 map_public_ip_on_launch = true

}

resource "aws_internet_gateway" "igw" {
 vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "public" {
 vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "igw-assoc" {
 route_table_id = aws_route_table.public.id
 destination_cidr_block = "0.0.0.0/0"
 gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
 route_table_id = aws_route_table.public.id
 subnet_id = aws_subnet.ec2-01.id

}
