variable "vpc_2_name" {
  type    = string
  default = "AcceptingVPC"
}
variable "vpc_2_cidr" {
  type    = string
  default = "10.200.0.0/16"
}
variable "vpc_2_azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}
variable "vpc_2_private_subnets" {
  type    = list(string)
  default = ["10.200.0.0/19", "10.200.32.0/19"]
}
variable "vpc_2_public_subnets" {
  type    = list(string)
  default = ["10.200.64.0/19", "10.200.96.0/19"]
}
variable "vpc_2_database_subnets" {
  type    = list(string)
  default = ["10.200.128.0/19", "10.200.160.0/19"]
}
variable "vpc_2_intra_subnets" {
  type    = list(string)
  default = ["10.200.192.0/19", "10.200.224.0/19"]
}