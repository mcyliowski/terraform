resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id        # używamy zmiennej, nie data source
  vpc_security_group_ids = var.vpc_security_group_ids

  tags = merge({
    Name = var.name
  }, var.tags)
}

