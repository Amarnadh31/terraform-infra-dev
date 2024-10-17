module "vpc" {
  source               = "git::https://github.com/Amarnadh31/terraform-aws-vpc.git"
  environment          = var.environment
  project              = var.project
  common_tags          = var.common_tags
  public_subnet_cidr   = var.public_subnet_cidr
  private_subnet_cidr  = var.private_subnet_cidr
  database_subnet_cidr = var.database_subnet_cidr
  peering_required     = var.peering_required

}

