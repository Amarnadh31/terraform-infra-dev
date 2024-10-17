output "vpc" {
  value = module.vpc
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "database_subnet_ids" {
  value = module.vpc.database_subnet_ids
}

output "public_routable_id" {
  value = module.vpc.public_route_id
}

output "private_routable_id" {
  value = module.vpc.private_route_id
}

output "database_routable_id" {
  value = module.vpc.database_route_id
}

output "database_group_name" {
  value = module.vpc.database_group_name
}



# output "az_names" {
#     value = module.vpc.az_id
# }