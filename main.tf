module "networking" {
  source = "./modules/networking"

  vpc_name        = "nc-ce-load-balacing-vpc"
  cidr_range      = "10.0.0.0/20"
  public_subnets  = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.8.0/24", "10.0.9.0/24", "10.0.10.0/24"]
}
