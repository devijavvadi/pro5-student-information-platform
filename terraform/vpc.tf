########################################
# VPC
########################################

resource "aws_vpc" "main" {

  cidr_block = "10.0.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "student-vpc"
  }
}

########################################
# Public Subnet 1
########################################

resource "aws_subnet" "public_subnet_1" {

  vpc_id = aws_vpc.main.id

  cidr_block = "10.0.1.0/24"

  availability_zone = "${var.aws_region}a"

  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1"
  }
}

########################################
# Public Subnet 2
########################################

resource "aws_subnet" "public_subnet_2" {

  vpc_id = aws_vpc.main.id

  cidr_block = "10.0.2.0/24"

  availability_zone = "${var.aws_region}b"

  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-2"
  }
}

########################################
# Private Subnet 1
########################################

resource "aws_subnet" "private_subnet_1" {

  vpc_id = aws_vpc.main.id

  cidr_block = "10.0.3.0/24"

  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "private-subnet-1"
  }
}

########################################
# Private Subnet 2
########################################

resource "aws_subnet" "private_subnet_2" {

  vpc_id = aws_vpc.main.id

  cidr_block = "10.0.4.0/24"

  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "private-subnet-2"
  }
}

########################################
# Internet Gateway
########################################

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "student-igw"
  }
}

########################################
# Public Route Table
########################################

resource "aws_route_table" "public_rt" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

########################################
# Route Table Association - Public 1
########################################

resource "aws_route_table_association" "public_1" {

  subnet_id = aws_subnet.public_subnet_1.id

  route_table_id = aws_route_table.public_rt.id
}

########################################
# Route Table Association - Public 2
########################################

resource "aws_route_table_association" "public_2" {

  subnet_id = aws_subnet.public_subnet_2.id

  route_table_id = aws_route_table.public_rt.id
}