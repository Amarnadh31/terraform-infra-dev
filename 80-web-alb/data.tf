data "aws_ssm_parameter" "web_alb_sg_id" {
  name = "/${var.project_name}/${var.environment_name}/web_alb_sg_id"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment_name}/vpc_id"
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project_name}/${var.environment_name}/public_subnet_ids"
}

data "aws_ssm_parameter" "web_acm" {
  name = "/${var.project_name}/${var.environment_name}/web_acm"
}