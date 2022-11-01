module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name = var.vpc_1_name
  cidr = var.vpc_1_cidr

  azs              = var.vpc_1_azs
  private_subnets  = var.vpc_1_private_subnets
  public_subnets   = var.vpc_1_public_subnets
  database_subnets = var.vpc_1_database_subnets
  intra_subnets    = var.vpc_1_intra_subnets

  enable_nat_gateway = true
}

resource "aws_vpc_peering_connection" "vpc1tovpc2" {
  peer_owner_id = var.account_id
  peer_vpc_id   = var.vpc2
  vpc_id        = module.vpc.vpc_id
  auto_accept   = true
}


# destination is the public subnets of the RequestingVPC
  resource "aws_route_table" "accepter_rt" {
    vpc_id = var.vpc2

    route {
      #needs to be vpc2 subnets
      cidr_block = module.vpc.public_subnets_cidr_blocks[0]
      vpc_peering_connection_id = aws_vpc_peering_connection.vpc1tovpc2.id
    }
    depends_on = [
      aws_vpc_peering_connection.vpc1tovpc2
    ]
  }

# destination is the private instance of the requester private vpc
resource "aws_route_table" "requester_rt" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id 
  }

  route {
    cidr_block = var.private_sn_vpc2
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc1tovpc2.id
  }
  depends_on = [
    aws_vpc_peering_connection.vpc1tovpc2
  ]
}
