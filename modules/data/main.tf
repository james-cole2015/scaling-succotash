data "aws_availability_zones" "zones" {}

data "aws_caller_identity" "current" {}

data "aws_internet_gateway" "vpc1" {
  filter {
    name   = "attachment.vpc-id"
    values = [var.vpc_1_id]
  }
}