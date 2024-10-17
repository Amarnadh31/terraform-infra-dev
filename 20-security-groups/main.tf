module "mysql" {
    source = "../../terraform-security-group-module"
    project_name = var.project_name
    sg_name = "mysql-sg"
    environment_name = var.environment_name
    vpc_id = local.vpc_id
    common_tags = var.common_tags
    sg_tags = var.mysql_sg_tags
}

module "backend" {
    source = "../../terraform-security-group-module"
    project_name = var.project_name
    sg_name = "backend-sg"
    environment_name = var.environment_name
    vpc_id = local.vpc_id
    common_tags = var.common_tags
    sg_tags = var.backend_sg_tags
}

module "frontend" {
    source = "../../terraform-security-group-module"
    project_name = var.project_name
    sg_name = "frontend-sg"
    environment_name = var.environment_name
    vpc_id = local.vpc_id
    common_tags = var.common_tags
    sg_tags = var.frontend_sg_tags

}

module "sebastian" {
    source = "../../terraform-security-group-module"
    project_name = var.project_name
    sg_name = "sebastian-sg"
    environment_name = var.environment_name
    vpc_id = local.vpc_id
    common_tags = var.common_tags
    sg_tags = var.sebastian_sg_tags

}

module "ansible" {
    source = "../../terraform-security-group-module"
    project_name = var.project_name
    sg_name = "ansible-sg"
    environment_name = var.environment_name
    vpc_id = local.vpc_id
    common_tags = var.common_tags
    sg_tags = var.ansible_sg_tags

}

module "app_alb" {
    source = "../../terraform-security-group-module"
    project_name = var.project_name
    sg_name = "app_alb-sg"
    environment_name = var.environment_name
    vpc_id = local.vpc_id
    common_tags = var.common_tags
    sg_tags = var.app_alb_sg_tags

}

module "vpn" {
    source = "../../terraform-security-group-module"
    project_name = var.project_name
    sg_name = "vpn-sg"
    environment_name = var.environment_name
    vpc_id = local.vpc_id
    common_tags = var.common_tags
    sg_tags = var.vpn_sg_tags

}

resource "aws_security_group_rule" "mysql_backend" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.backend.sg_id
  security_group_id = module.mysql.sg_id

}

# resource "aws_security_group_rule" "backend_front" {
#   type              = "ingress"
#   from_port         = 8080
#   to_port           = 8080
#   protocol          = "tcp"
#   source_security_group_id = module.frontend.sg_id
#   security_group_id = module.backend.sg_id

# }


# resource "aws_security_group_rule" "frontend_public" {
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   cidr_blocks  = ["0.0.0.0/0"]
#   security_group_id = module.frontend.sg_id

# }


resource "aws_security_group_rule" "mysql_sebastian" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.sebastian.sg_id
  security_group_id = module.mysql.sg_id

}


resource "aws_security_group_rule" "backend_sebastian" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.sebastian.sg_id
  security_group_id = module.backend.sg_id

}

resource "aws_security_group_rule" "frontend_sebastian" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.sebastian.sg_id
  security_group_id = module.frontend.sg_id

}

resource "aws_security_group_rule" "sebastian_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks  = ["0.0.0.0/0"]
  security_group_id = module.sebastian.sg_id

}

# resource "aws_security_group_rule" "mysql_ansible" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   source_security_group_id = module.ansible.sg_id
#   security_group_id = module.mysql.sg_id

# }

resource "aws_security_group_rule" "backend_ansible" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.ansible.sg_id
  security_group_id = module.backend.sg_id

}

resource "aws_security_group_rule" "frontend_ansible" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.ansible.sg_id
  security_group_id = module.frontend.sg_id

}



resource "aws_security_group_rule" "ansible_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks  = ["0.0.0.0/0"]
  security_group_id = module.ansible.sg_id

}

resource "aws_security_group_rule" "backend_app_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb.sg_id
  security_group_id = module.backend.sg_id

}

resource "aws_security_group_rule" "sebastian_app_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.sebastian.sg_id
  security_group_id = module.app_alb.sg_id

}

resource "aws_security_group_rule" "vpn_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks  = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id

}

resource "aws_security_group_rule" "vpn_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks  = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id

}


resource "aws_security_group_rule" "vpn_443" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks  = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id

}


resource "aws_security_group_rule" "vpn_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "tcp"
  cidr_blocks  = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id

}

resource "aws_security_group_rule" "app_alb_vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.app_alb.sg_id

}

resource "aws_security_group_rule" "backend_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.backend.sg_id

}

resource "aws_security_group_rule" "backend_vpn_8080" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.backend.sg_id

}