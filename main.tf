#----------------------------------------------------------------#
##                      VPCs & Subnets                          ##
#----------------------------------------------------------------#
data "aws_availability_zones" "zones" {}

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
  vpc_id                  = aws_vpc.requesting_vpc.id
  cidr_block              = "10.100.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "requesting-subnet"
  }
}

resource "aws_subnet" "accepting_subnet" {
  vpc_id                  = aws_vpc.accepting_vpc.id
  cidr_block              = "10.200.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "accepting-subnet"
  }
}

#----------------------------------------------------------------#
##                      IGWs & Routes                           ##
#----------------------------------------------------------------#

resource "aws_internet_gateway" "requesting-igw" {
  vpc_id = aws_vpc.requesting_vpc.id
  tags = {
    Name = "requesting-igw"
  }
}

resource "aws_internet_gateway" "accepting-igw" {
  vpc_id = aws_vpc.accepting_vpc.id
  tags = {
    Name = "accepting-igw"
  }
}

resource "aws_default_route_table" "requesting-route-table" {
  default_route_table_id = aws_vpc.requesting_vpc.main_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.requesting-igw.id
  }
    route {
    cidr_block = "10.200.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.foo.id 
  }
    tags = {
    Name = "requesting-vpc-route-table"
  }
}

resource "aws_default_route_table" "accepting-route-table" {
  default_route_table_id = aws_vpc.accepting_vpc.main_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.accepting-igw.id
  }
  tags = {
    Name = "accepting-vpc-route-table"
  }
  route {
    cidr_block = "10.100.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.foo.id 
  }
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
    cidr_blocks = ["54.161.110.139/32","10.100.0.0/16"]
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
  vpc_id = aws_vpc.requesting_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["54.161.110.139/32","10.200.0.0/16"]
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
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.requesting_subnet.id
  key_name        = data.aws_key_pair.mdaviskey.key_name
  security_groups = [aws_security_group.allow_ssh_requesting.id]

  tags = {
    Name = "RequestingEC2"
  }
}

resource "aws_instance" "accepting_ec2" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.accepting_subnet.id
  key_name        = data.aws_key_pair.mdaviskey.key_name
  security_groups = [aws_security_group.allow_ssh_accepting.id]

  tags = {
    Name = "AcceptingEC2"
  }
}


#----------------------------------------------------------------#
##                       VPC Peering                            ##
#----------------------------------------------------------------#

resource "aws_vpc_peering_connection" "foo" {
  peer_vpc_id   = aws_vpc.accepting_vpc.id 
  vpc_id        = aws_vpc.requesting_vpc.id
  auto_accept   = true
}

#----------------------------------------------------------------#
##                  VPC Flow Logging                            ##
#----------------------------------------------------------------#

resource "aws_flow_log" "flow_logs_example" {
  iam_role_arn = aws_iam_role.example.arn
  log_destination = aws_cloudwatch_log_group.example.arn
  traffic_type = "ALL"
  vpc_id = aws_vpc.requesting_vpc.vpc_id
}

resource "aws_cloudwatch_log_group" "example" {
  name = "vpc_logs"
}

resource "aws_iam_role" "example" {
  name = "example"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "example" {
  name = "example"
  role = aws_iam_role.example.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}