# Sets up the vpc, subnets and internet gateway
module "networking" {
    source = "./modules/networking"
    vpc_name = var.vpc_name
}