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

variable "sg_tags" {
    default = {}
}

variable "mysql_sg_tags" {
    default = {
        component = "mysql"
    }
}

variable "backend_sg_tags" {
    default = {
        component = "backend"
    }
}

variable "frontend_sg_tags" {
    default = {
        component = "frontend"
    }
}

variable "sebastian_sg_tags" {
    default = {
        component = "sebastian"
    }
}

variable "ansible_sg_tags" {
    default = {
        component = "ansible"
    }
}

variable "app_alb_sg_tags" {
    default = {
        component = "app_alb"
    }
}

variable "vpn_sg_tags" {
    default = {
        component = "app_alb"
    }
}