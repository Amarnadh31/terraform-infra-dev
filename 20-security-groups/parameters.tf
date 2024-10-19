resource "aws_ssm_parameter" "sebastian_sg_id" {
  name  = "/${var.project_name}/${var.environment_name}/sebastian_sg_id"
  type  = "String"
  value = module.sebastian.sg_id
}

resource "aws_ssm_parameter" "mysql_sg_id" {
  name  = "/${var.project_name}/${var.environment_name}/mysql_sg_id"
  type  = "String"
  value = module.mysql.sg_id
}

resource "aws_ssm_parameter" "backend_sg_id" {
  name  = "/${var.project_name}/${var.environment_name}/backend_sg_id"
  type  = "String"
  value = module.backend.sg_id
}

resource "aws_ssm_parameter" "frontend_sg_id" {
  name  = "/${var.project_name}/${var.environment_name}/frontend_sg_id"
  type  = "String"
  value = module.frontend.sg_id
}

resource "aws_ssm_parameter" "ansible_sg_id" {
  name  = "/${var.project_name}/${var.environment_name}/ansible_sg_id"
  type  = "String"
  value = module.ansible.sg_id
}

resource "aws_ssm_parameter" "app_alb_sg_id" {
  name  = "/${var.project_name}/${var.environment_name}/app_alb_sg_id"
  type  = "String"
  value = module.app_alb.sg_id
}

resource "aws_ssm_parameter" "web_alb_sg_id" {
  name  = "/${var.project_name}/${var.environment_name}/web_alb_sg_id"
  type  = "String"
  value = module.web_alb.sg_id
}

resource "aws_ssm_parameter" "vpn_sg_id" {
  name  = "/${var.project_name}/${var.environment_name}/vpn_sg_id"
  type  = "String"
  value = module.vpn.sg_id
}