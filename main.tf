#----------------------------------------------------------------#
##                 Creating VPCs & Subnets                      ##
#----------------------------------------------------------------#
data "aws_availability_zones" "zones" {}

module "requesting_vpc" {
  source         = "terraform-aws-modules/vpc/aws"
  version        = "3.18.1"
  azs            = data.aws_availability_zones.zones.names 
  cidr           = "10.100.0.0/16"
  create_igw     = true
  public_subnets = ["10.100.0.0/24"]
  public_subnet_names = ["requesting-subnet"]
  /*default_route_table_routes {
    route {
      cidr_block = "10.200.0.0/16"
      gateway_id = module.requesting_vpc.public_internet_gateway_route_id
    }
  }*/
}
/*
module "requesting_vpc" {
  source         = "terraform-aws-modules/vpc/aws"
  version        = "3.18.1"
  cidr           = "10.200.0.0/16"
  create_igw     = true
  public_subnets = ["10.200.0.0/24"]
}

#----------------------------------------------------------------#
##                    EC2 Securty Groups                        ##
#----------------------------------------------------------------#

resource "aws_security_group" "allow_ssh_accepting" {
  name   = "allow ssh from accepting"
  vpc_id = aws_vpc.accepting_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["54.161.110.139/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_ssh_requesting" {
  name   = "allow ssh from requesting"
  vpc_id = module.requesting_vpc.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["54.161.110.139/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#----------------------------------------------------------------#
##                  Retrieving Stored KeyPair                   ##
#----------------------------------------------------------------#

data "aws_key_pair" "mdaviskey" {
  key_name           = "m-davis-key"
  include_public_key = true
}

output "m-davis-keyname" {
  value = data.aws_key_pair.mdaviskey.key_name
}

output "m-davis-public_key-key" {
  value = data.aws_key_pair.mdaviskey.public_key
}

#----------------------------------------------------------------#
##                     Getting Ubuntu AMI                       ##
#----------------------------------------------------------------#

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
#----------------------------------------------------------------#
##                  Creating EC2 instances                      ##
#----------------------------------------------------------------#

resource "aws_instance" "requesting_ec2" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t3.micro"
  subnet_id       = aws_subnet.requesting_subnet.id
  key_name        = data.aws_key_pair.mdaviskey.key_name
  security_groups = [aws_security_group.allow_ssh_requesting.id]

  tags = {
    Name = "RequestingEC2"
  }
}

resource "aws_instance" "accepting_ec2" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t3.micro"
  subnet_id       = aws_subnet.accepting_subnet.id
  key_name        = data.aws_key_pair.mdaviskey.key_name
  security_groups = [aws_security_group.allow_ssh_accepting.id]

  tags = {
    Name = "AcceptingEC2"
  }
}*/