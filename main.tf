
module "vpc1" {
  source          = "./modules/vpc_1"
  vpc2            = module.vpc2.vpc2info.vpc_id
  account_id      = module.aws_data.callerinfo.account_id
  igw_id          = module.aws_data.vpc_1_igw.id
  private_sn_vpc2 = module.vpc2.vpc2info.private_subnets_cidr_blocks[0]
}

module "vpc2" {
  source = "./modules/vpc2"
}

module "aws_data" {
  source   = "./modules/data"
  vpc_1_id = module.vpc1.vpc1info.vpc_id
}
