variable "project_name" {
    default = "expense"
}

variable "environment_name" {
    default = "dev"
}

variable "common_tags" {
    default = {
        Project = "expense"
        Environment = "dev"
        Terraform = true 
    }
}

variable "backend_tags" {
    default = {
        component = "backend"
    }
}

variable "zone_name" {
    default = "expensemind.online"
}