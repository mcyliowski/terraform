##############################################
# ECS CLUSTER
##############################################

resource "aws_ecs_cluster" "app" {
  name = "ecs-app-cluster"
}

##############################################
# SECURITY GROUP FOR ECS SERVICE
##############################################

resource "aws_security_group" "ecs_service" {
  name        = "ecs-service-sg"
  description = "Security group for ECS service"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Terraform   = "true"
    Environment = "Managed by Terraform"
  }
}

##############################################
# CLOUDWATCH LOG GROUPS
##############################################

resource "aws_cloudwatch_log_group" "frontend" {
  name              = "/ecs/frontend"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "backend" {
  name              = "/ecs/backend"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "mongodb" {
  name              = "/ecs/mongodb"
  retention_in_days = 7
}

##############################################
# ECS TASK DEFINITION
##############################################

resource "aws_ecs_task_definition" "app" {
  family                   = "ecs-app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = var.ecs_task_exec_role

  container_definitions = jsonencode([
    {
      name      = "frontend"
      image     = var.frontend_image
      essential = true
      portMappings = [{ containerPort = 80, protocol = "tcp" }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.frontend.name
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "frontend"
        }
      }
    },
    {
      name      = "backend"
      image     = var.backend_image
      essential = true
      dependsOn = [
        { containerName = "mongodb", condition = "START" }
      ]
      portMappings = [{ containerPort = 3000, protocol = "tcp" }]
      environment = [
        { name = "MONGO_URI", value = "mongodb://admin:nimda@127.0.0.1:27017/testdb?authSource=admin" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.backend.name
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "backend"
        }
      }
    },
    {
      name      = "mongodb"
      image     = var.mongodb_image
      essential = true
      portMappings = [{ containerPort = 27017, protocol = "tcp" }]
      environment = [
        { name = "MONGO_INITDB_ROOT_USERNAME", value = "admin" },
        { name = "MONGO_INITDB_ROOT_PASSWORD", value = "nimda" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.mongodb.name
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "mongodb"
        }
      }
    }
  ])
}

##############################################
# ECS SERVICE
##############################################

resource "aws_ecs_service" "app" {
  name            = "ecs-app-service"
  cluster         = aws_ecs_cluster.app.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.public_subnets
    security_groups  = [aws_security_group.ecs_service.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.frontend_tg_arn
    container_name   = "frontend"
    container_port   = 80
  }

  load_balancer {
    target_group_arn = var.backend_tg_arn
    container_name   = "backend"
    container_port   = 3000
  }

  depends_on = [
    aws_ecs_task_definition.app,
    aws_cloudwatch_log_group.frontend,
    aws_cloudwatch_log_group.backend,
    aws_cloudwatch_log_group.mongodb
  ]
}

##############################################
# OUTPUTS
##############################################

output "ecs_service_sg" {
  value = aws_security_group.ecs_service.id
}

output "task_definition" {
  value = aws_ecs_task_definition.app.arn
}

output "cluster_name" {
  value = aws_ecs_cluster.app.name
}
