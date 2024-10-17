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

variable "app_alb_tags" {
    default = {
        component = "app_alb"
    }
}

variable "zone_name" {
    default = "expensemind.online"
}