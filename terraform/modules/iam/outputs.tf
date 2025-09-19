output "exec_role_arn" {
  value       = aws_iam_role.ecs_execution_role.arn
  description = "ECS execution role ARN"
}


output "task_role_arn" {
  value       = aws_iam_role.ecs_task_role.arn
  description = "ECS task role ARN"
}

output "codedeploy_role_arn" {
  value       = aws_iam_role.codedeploy_role.arn
  description = "CodeDeploy role ARN"
}