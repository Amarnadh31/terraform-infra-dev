module "frontend" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = local.resource_name
  

  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.frontend_sg_id.value]
  subnet_id              = local.public_subnet_id
  ami = data.aws_ami.frontend_ami.id

  tags = merge (
    var.common_tags,
    var.frontend_tags,
    {
        Name = local.resource_name
    }
  )
}

resource "null_resource" "cluster" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.frontend.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host = module.frontend.private_ip
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
  }

  provisioner "file" {
    source      = "${var.frontend_tags.component}.sh"
    destination = "/tmp/frontend.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/frontend.sh",
      "sudo sh /tmp/frontend.sh ${var.frontend_tags.component} ${var.environment_name}"
    ]
  }
}

resource "aws_ec2_instance_state" "frontend_stop" {
  instance_id = module.frontend.id
  state       = "stopped"
  depends_on = [ null_resource.cluster ]
}

resource "aws_ami_from_instance" "frontend_ami" {
  name               = local.resource_name
  source_instance_id = module.frontend.id
  depends_on = [ aws_ec2_instance_state.frontend_stop ]
}


resource "null_resource" "frontend_destroy" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.frontend.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case

  provisioner "local-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    command = "aws ec2 terminate-instances --instance-ids ${module.frontend.id}"
  }

  depends_on = [ aws_ami_from_instance.frontend_ami ]
}



resource "aws_launch_template" "frontend_template" {
  name = local.resource_name

  image_id = aws_ami_from_instance.frontend_ami.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t2.micro"
  vpc_security_group_ids = [local.frontend_sg_id]
  update_default_version = true

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = local.resource_name
    }
  }

}


resource "aws_lb_target_group" "frontend_tg" {
  name     = local.resource_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = local.vpc_id


  health_check {
    healthy_threshold =2
    unhealthy_threshold = 2
    protocol = "HTTP"
    port = 80
    path = "/"
    matcher = "200-299"
    interval = 5
    timeout = 4
  }
}


resource "aws_autoscaling_group" "frontend_auto_scale" {
  name                      = local.resource_name
  max_size                  = 10
  min_size                  = 2
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 2
  # force_delete              = true
  vpc_zone_identifier       = [local.public_subnet_id]
  target_group_arns = [aws_lb_target_group.frontend_tg.arn]


instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }

  launch_template {
    id      = aws_launch_template.frontend_template.id
    version = "$Latest"
  }


  tag {
    key                 = "Name"
    value               = local.resource_name
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "Project"
    value               = "expense"
    propagate_at_launch = false
  }
}


resource "aws_autoscaling_policy" "frontend" {
  autoscaling_group_name = aws_autoscaling_group.frontend_auto_scale.name
  name                   = local.resource_name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
  predefined_metric_specification {
    predefined_metric_type = "ASGAverageCPUUtilization"
       
    }
   target_value = 70.0
  }
}


resource "aws_lb_listener_rule" "host_based_weighted_routing" {
  listener_arn = local.frontend_listener_arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }

  condition {
    host_header {
      values = ["expense-${var.environment_name}.${var.zone_name}"]
    }
  }
}