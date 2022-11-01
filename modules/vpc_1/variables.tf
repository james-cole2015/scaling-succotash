variable "vpc_1_name" {
  type    = string
  default = "incognito-monkey"
}
variable "vpc_1_cidr" {
  type    = string
  default = "10.100.0.0/16"
}
variable "vpc_1_azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}
variable "vpc_1_private_subnets" {
  type    = list(string)
  default = ["10.100.0.0/19", "10.100.32.0/19"]
}
variable "vpc_1_public_subnets" {
  type    = list(string)
  default = ["10.100.64.0/19", "10.100.96.0/19"]
}
variable "vpc_1_database_subnets" {
  type    = list(string)
  default = ["10.100.128.0/19", "10.100.160.0/19"]
}
variable "vpc_1_intra_subnets" {
  type    = list(string)
  default = ["10.100.192.0/19", "10.100.224.0/19"]
}