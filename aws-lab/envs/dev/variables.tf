variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "aws_ami_id" {
  type    = string
  default = "ami-0c55b159cbfafe1f0"  # Debian 10 w us-east-1
}

variable "key_name" {
  type    = string
  default = "michal_cyliowski_test"
}
