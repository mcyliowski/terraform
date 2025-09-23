variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

provider "aws" {
  region = var.aws_region
  profile = "default"
}
