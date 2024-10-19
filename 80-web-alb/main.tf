module "web_alb" {
  source = "terraform-aws-modules/alb/aws"

  internal = false
  name    = local.resource_name
  vpc_id  = local.vpc_id
  subnets = local.public_subnet_ids
  # Security Group
  security_groups = [local.web_alb_sg_id]
  create_security_group = false
  enable_deletion_protection = false

  tags = merge(
    var.common_tags,
    var.web_alb_tags
  )
}

resource "aws_lb_listener" "web_alb" {
  load_balancer_arn = module.web_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Hi i'm from Andhra"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener" "web_alb_https" {
  load_balancer_arn = module.web_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = local.web_acm

 default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "I'm from https listener"
      status_code  = "200"
    }
  }
}


module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = var.zone_name

  records = [
    {
      name    = "expense-${var.environment_name}"
      type    = "A"
      alias   = {
        name    = module.web_alb.dns_name
        zone_id = module.web_alb.zone_id
      }
    }
  ]

}
