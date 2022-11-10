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