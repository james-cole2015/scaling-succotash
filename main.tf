
module "vpc1" {
  source     = "./modules/vpc_1"
  vpc2       = module.vpc2.vpc2info.vpc_id
  account_id = module.aws_data.callerinfo.account_id
}

module "vpc2" {
  source = "./modules/vpc2"
}

module "aws_data" {
  source = "./modules/data"
}
