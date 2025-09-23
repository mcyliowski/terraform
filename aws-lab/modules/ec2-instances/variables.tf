variable "name" {}
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "subnet_id" {}
variable "vpc_security_group_ids" {
  type = list(string)
}
variable "tags" {
  type    = map(string)
  default = {}
}
