# AWS Configuration
aws_region = "us-east-1"

# AWS domain config
domain_name   = "test.wbd.actor"
app_subdomain = "jakibuildwariacie"

# Docker images
frontend_image = "cyna58/nauka-kubernetes:frontend_reset_v2"
backend_image  = "cyna58/nauka-kubernetes:backend-poe_v1"
mongodb_image  = "cyna58/nauka_kubernetes:mongodb-k8s"

# ECS task config
desired_count      = 1
task_cpu           = 1024
task_memory        = 4096
log_retention_days = 14

