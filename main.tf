module "networking" {
  source = "./modules/networking"

  vpc_name           = "nc_ce_load_balacing_vpc"
  cidr_range         = "10.0.0.0/20"
  availability_zones = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  public_subnets     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  private_subnets    = ["10.0.8.0/24", "10.0.9.0/24", "10.0.10.0/24"]
}

module "security" {
  source = "./modules/security"

  vpc_id = module.networking.vpc_id
}

module "app_servers" {
  source = "./modules/app_servers"

  security_group = module.security.security_group_id

  vpc_id = module.networking.vpc_id

  subnet_ids = module.networking.public_subnets
}

module "load_balancing" {
  source = "./modules/load_balancing"

  vpc_id = module.networking.vpc_id

  target_ids = module.app_servers.instance_ids
}