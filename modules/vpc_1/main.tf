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
