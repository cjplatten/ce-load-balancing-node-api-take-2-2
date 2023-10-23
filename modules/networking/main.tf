# If this module doesn't do anything other than use the existing
# public AWS VPC module then there is a case for it not needing to
# reside within the modules directory and the AWS VPC module could 
# just be used from the root main.tf file

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = var.vpc_name

  cidr = var.cidr_range

  # Should probably make these variables
  # but considering we've locked down accounts to
  # only allow UK region then this is ok
  azs = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]

  public_subnet_suffix = "public"
  public_subnets       = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
  private_subnets      = ["10.0.96.0/20", "10.0.112.0/20", "10.0.128.0/20"]

  create_igw = true
}
