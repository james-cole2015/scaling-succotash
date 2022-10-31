module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name = var.vpc_1_name
  cidr = var.vpc_1_cidr

  azs              = var.vpc_1_azs
  private_subnets  = var.vpc_1_private_subnets
  public_subnets   = var.vpc_1_public_subnets
  database_subnets = var.vpc_1_database_subnets

  enable_nat_gateway = true
}
