locals {
    resource_name = "${var.project_name}-${var.environment_name}-frontend"
    public_subnet_id = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]
    frontend_sg_id = data.aws_ssm_parameter.frontend_sg_id.value
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    frontend_listener_arn = data.aws_ssm_parameter.frontend_listener_arn.value
}