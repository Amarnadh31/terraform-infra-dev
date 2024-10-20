module "backend" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = local.resource_name

  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.backend_sg_id.value]
  subnet_id              = local.private_subnet_id
  ami = data.aws_ami.backend_ami.id

  tags = merge (
    var.common_tags,
    var.backend_tags,
    {
        Name = local.resource_name
    }
  )
}





resource "null_resource" "backend" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.backend.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host = module.backend.private_ip
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
  }

  provisioner "file" {
    source      = "${var.backend_tags.component}.sh"
    destination = "/tmp/backend.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/backend.sh",
      "sudo sh /tmp/backend.sh ${var.backend_tags.component} ${var.environment_name}"
    ]
  }
}

resource "aws_ec2_instance_state" "backend_stop" {
  instance_id = module.backend.id
  state       = "stopped"
  depends_on = [ null_resource.backend ]
}

resource "aws_ami_from_instance" "backend_ami" {
  name               = local.resource_name
  source_instance_id = module.backend.id
  depends_on = [ aws_ec2_instance_state.backend_stop ]
}

resource "null_resource" "backend_delete" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.backend.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case

  provisioner "local-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    command = "aws ec2 terminate-instances --instance-ids ${module.backend.id}"
  }
  depends_on = [ aws_ami_from_instance.backend_ami ]
}


resource "aws_lb_target_group" "backend_tg" {
  name     = local.resource_name
  port     = 8080
  protocol = "HTTP"
  vpc_id   = local.vpc_id

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    matcher = "200-299"
    timeout = 4
    interval = 5
    protocol = "HTTP"
    port = 8080
    path = "/health"
  }
}



resource "aws_launch_template" "backend_template" {
  name = local.resource_name

  image_id = aws_ami_from_instance.backend_ami.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t2.micro"
  vpc_security_group_ids = [local.backend_sg_id]
  update_default_version = true

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = local.resource_name
    }
  }

  
}




resource "aws_autoscaling_group" "backend" {
  name                      = local.resource_name
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 2
  target_group_arns = [aws_lb_target_group.backend_tg.arn]
  # force_delete              = true
  vpc_zone_identifier       = [local.private_subnet_id]

   instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }

 launch_template {
    id      = aws_launch_template.backend_template.id
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
    value               = "Expense"
    propagate_at_launch = false
  }
}



resource "aws_autoscaling_policy" "backend" {
  name                   = local.resource_name
  autoscaling_group_name = aws_autoscaling_group.backend.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
  predefined_metric_specification {
    predefined_metric_type = "ASGAverageCPUUtilization"
  }

  target_value = 70.0
}
}


resource "aws_lb_listener_rule" "host_based_weighted_routing" {
  listener_arn = local.backend_listener_arn
  priority     = 99 # lowest number have highest priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }

  condition {
    host_header {
      values = ["${var.backend_tags.component}.app-${var.environment_name}.${var.zone_name}"]
    }
  }
}

