variable "environment" {
  default = "dev"
}

variable "project" {
  default = "expense"
}

variable "common_tags" {
  default = {
    Project     = "expense"
    Environment = "dev"
    terraform   = true
  }
}

variable "public_subnet_cidr" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr" {
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "database_subnet_cidr" {
  default = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "peering_required" {
  default = false
}