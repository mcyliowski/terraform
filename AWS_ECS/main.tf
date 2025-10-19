module "vpc" {
  source = "./vpc"

  name             = "app-vpc"
  cidr             = "10.0.0.0/16"
  azs              = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets   = ["10.0.0.0/24", "10.0.4.0/24"]
  private_subnets  = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
  enable_nat_gateway = true
  single_nat_gateway = true
  tags = { Terraform="true", Environment="Managed by Terraform" }
}

module "iam" {
  source = "./iam"
}

module "alb" {
  source = "./alb"

  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
}

module "ecs" {
  source = "./ecs"

  vpc_id             = module.vpc.vpc_id
  public_subnets     = module.vpc.public_subnets
  ecs_task_exec_role = module.iam.ecs_task_exec_role_arn
  frontend_image     = var.frontend_image
  backend_image      = var.backend_image
  mongodb_image      = var.mongodb_image
  task_cpu           = var.task_cpu
  task_memory        = var.task_memory
  desired_count      = var.desired_count
  frontend_tg_arn    = module.alb.frontend_tg_arn
  backend_tg_arn     = module.alb.backend_tg_arn
  alb_sg_id          = module.alb.alb_sg_id
}

module "route53" {
  source = "./route53"

  domain_name = var.domain_name
  subdomain   = var.app_subdomain
  alb_dns     = module.alb.alb_dns_name
  alb_zone_id = module.alb.alb_zone_id
}

output "app_url" {
  value = module.route53.frontend_url
}
