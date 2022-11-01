output "az_names" {
  value = data.aws_availability_zones.zones
}

output "callerinfo" {
  value = data.aws_caller_identity.current
}

output "vpc_1_igw" {
  value = data.aws_internet_gateway.vpc1
}