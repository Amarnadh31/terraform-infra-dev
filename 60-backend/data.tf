data "aws_ssm_parameter" "backend_sg_id" {
  name = "/${var.project_name}/${var.environment_name}/backend_sg_id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project_name}/${var.environment_name}/private_subnet_ids"
}

data "aws_ami" "backend_ami"{
    most_recent = true
    owners = ["973714476881"]

    filter {
        name = "name"
        values = ["RHEL-9-DevOps-Practice"]
    }
    filter {
        name = "root-device-type"
        values = ["ebs"]
    }
}