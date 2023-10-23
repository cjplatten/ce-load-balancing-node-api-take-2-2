# 4096 should be more than enough!
variable "cidr_range" {
  type    = string
}

variable "vpc_name" {
  type    = string
}

variable "public_subnets" {
  type    = list(string)
}

variable "private_subnets" {
  type    = list(string)
}