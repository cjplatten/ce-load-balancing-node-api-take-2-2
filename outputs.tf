output "vpc_id" {
  value = module.networking.vpc_id
}

output "security_group_id" {
  value = module.security.security_group_id
}