locals {
  resource_name = "${var.project_name}-${var.environment_name}"  
  web_alb_sg_id = data.aws_ssm_parameter.web_alb_sg_id.value
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  public_subnet_ids = split(",", data.aws_ssm_parameter.public_subnet_ids.value)
  web_acm = data.aws_ssm_parameter.web_acm.value
}