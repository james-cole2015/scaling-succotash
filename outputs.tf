output "availability_zones" {
  value = module.aws_data.az_names
}

output "first three" {
  value = module.aws_data.az_names[-2]
}
