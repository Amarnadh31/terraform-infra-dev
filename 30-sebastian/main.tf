module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = local.resource_name

  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.sebastian_sg_id.value]
  subnet_id              = local.public_subnet_id
  ami = data.aws_ami.sebastian_ami.id

  tags = merge (
    var.common_tags,
    var.sebastian_tags,
    {
        Name = local.resource_name
    }
  )
}