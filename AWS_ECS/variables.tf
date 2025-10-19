variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "frontend_image" {
  description = "Docker image for frontend"
}

variable "backend_image" {
  description = "Docker image for backend"
}

variable "mongodb_image" {
  description = "Docker image for MongoDB"
}

variable "task_cpu" {
  description = "CPU for ECS task"
  default     = 512
}

variable "task_memory" {
  description = "Memory for ECS task"
  default     = 1024
}

variable "desired_count" {
  description = "Number of ECS task replicas"
  default     = 1
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  default     = 7
}

variable "domain_name" {
  description = "Domain for Route53"
}

variable "app_subdomain" {
  description = "Subdomain for application"
}
