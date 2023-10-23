variable "vpc_name" {
  type = string
}

# 4096 should be more than enough!
variable "cidr_range" {
  type    = string
  default = "10.0.0.0/20"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.8.0/24", "10.0.9.0/24", "10.0.10.0/24"]
}
