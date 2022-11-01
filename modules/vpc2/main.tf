module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name = var.vpc_2_name
  cidr = var.vpc_2_cidr

  azs              = var.vpc_2_azs
  private_subnets  = var.vpc_2_private_subnets
  public_subnets   = var.vpc_2_public_subnets
  database_subnets = var.vpc_2_database_subnets
  intra_subnets    = var.vpc_2_intra_subnets

  enable_nat_gateway = true
}
