variable "vpc_id" {}
variable "ecs_task_exec_role" {}
variable "frontend_image" {}
variable "backend_image" {}
variable "mongodb_image" {}
variable "task_cpu" { default = "512" }
variable "task_memory" { default = "1024" }
variable "desired_count" { default = 1 }
variable "log_retention_days" { default = 7 }
variable "frontend_tg_arn" {}
variable "backend_tg_arn" {}
variable "public_subnets" {type= list(string)}
variable "alb_sg_id" { type = string}