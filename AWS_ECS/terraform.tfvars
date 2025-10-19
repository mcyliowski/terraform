# AWS Configuration
aws_region = "us-east-1"

# AWS domain config
domain_name   = "test.wbd.actor"
app_subdomain = "app"

# Docker images
frontend_image = "cyna58/nauka_v1:poe_v1.1"
backend_image  = "cyna58/nauka_v1:backend_v2.1"
mongodb_image  = "cyna58/nauka_v1:mongo_v2"

# ECS task config
desired_count      = 1
task_cpu           = 1024
task_memory        = 4096
log_retention_days = 14

