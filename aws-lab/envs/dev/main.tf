provider "aws" {
  region = var.aws_region
}


# Pobranie domyślnego VPC
data "aws_vpc" "default" {
  default = true
}

# Pobranie wszystkich subnetów w domyślnym VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security group do SSH
resource "aws_security_group" "ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

# Moduły EC2
module "control_node" {
  source                  = "../../modules/ec2-instances"
  name                    = "control-node"
  ami_id                  = var.aws_ami_id
  instance_type           = var.aws_instance_type
  key_name                = var.key_name
  subnet_id               = element(data.aws_subnets.default.ids, 0)
  vpc_security_group_ids  = [aws_security_group.ssh.id]
  tags = {
    Environment = "dev"
    Role        = "ansible-master"
  }
}

module "managed_node_1" {
  source                  = "../../modules/ec2-instances"
  name                    = "managed-node-1"
  ami_id                  = var.aws_ami_id
  instance_type           = var.aws_instance_type
  key_name                = var.key_name
  subnet_id               = element(data.aws_subnets.default.ids, 0)
  vpc_security_group_ids  = [aws_security_group.ssh.id]
  tags = {
    Environment = "dev"
    Role        = "ansible-node"
  }
}

module "managed_node_2" {
  source                  = "../../modules/ec2-instances"
  name                    = "managed-node-2"
  ami_id                  = var.aws_ami_id
  instance_type           = var.aws_instance_type
  key_name                = var.key_name
  subnet_id               = element(data.aws_subnets.default.ids, 0)
  vpc_security_group_ids  = [aws_security_group.ssh.id]
  tags = {
    Environment = "dev"
    Role        = "ansible-node"
  }
}

output "control_node_public_ip" {
  value = module.control_node.public_ip
}

output "managed_node_1_public_ip" {
  value = module.managed_node_1.public_ip
}

output "managed_node_2_public_ip" {
  value = module.managed_node_2.public_ip
}