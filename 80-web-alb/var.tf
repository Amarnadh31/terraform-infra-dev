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

variable "web_alb_tags" {
    default = {
        component = "web_alb"
    }
}

variable "zone_name" {
    default = "expensemind.online"
}