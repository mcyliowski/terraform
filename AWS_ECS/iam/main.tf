resource "aws_iam_role" "ecs_task_exec_role" {
  name = "ecsTaskExecutionRoleTerraform"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action   = "sts:AssumeRole"
    }]
  })

  tags = {
    Terraform   = "true"
    Environment = "Managed by Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec_role_policy" {
  role       = aws_iam_role.ecs_task_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

output "ecs_task_exec_role_arn" {
  value = aws_iam_role.ecs_task_exec_role.arn
}
