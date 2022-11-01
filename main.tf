
module "vpc1" {
  source = "./modules/vpc_1"
}

module "vpc2" {
  source = "./modules/vpc2"
}

module "aws_data" {
  source = "./modules/data"
}