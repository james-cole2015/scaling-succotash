
module "vpc1" {
  source = "./modules/vpc_1"
}


module "aws_data" {
  source = "./modules/data"
}