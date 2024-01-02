variable security_group {
    type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
    type = list(string)
}