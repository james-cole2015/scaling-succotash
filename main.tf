/*
module "vpc1" {
    source = "./modules/vpc_1"
    azs = aws_data.aws_az_names.names["0:2"]
}

module "vpc2" {
    source = "./modules/vpc_2"
    azs = aws_data.aws_az_names.names["0:2"]
}
*/
module "aws_data" {
  source = "./modules/data"
}