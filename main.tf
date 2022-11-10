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

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "requesting_ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.requesting_subnet.id

  tags = {
    Name = "RequestingEC2"
  }
}

resource "aws_instance" "accepting_ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.accepting_subnet.id

  tags = {
    Name = "AcceptingEC2"
  }
}