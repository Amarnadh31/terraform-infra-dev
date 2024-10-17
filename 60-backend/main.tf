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