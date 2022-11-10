resource "aws_vpc" "requesting_vpc" {
  cidr_block = "10.100.0.0/16"
  tags = {
    Name = "requesting-vpc"
  }
}

resource "aws_vpc" "accepting_vpc" {
  cidr_block = "10.200.0.0/16"
    tags = {
    Name = "accepting-vpc"
  }
}

resource "aws_subnet" "requesting_subnet" {
  vpc_id = aws_vpc.requesting_vpc.id
  cidr_block = "10.100.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "requesting-subnet"
  }
}

resource "aws_subnet" "accepting_subnet" {
  vpc_id = aws_vpc.accepting_vpc.id
  cidr_block = "10.200.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "accepting-subnet"
  }
}