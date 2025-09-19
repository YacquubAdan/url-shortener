variable "codedeploy_role_arn" {
  type        = string
  description = "CodeDeploy role ARN"
}

variable "ecs_cluster_name" {
  type = string
  description = "Name of the ECS cluster"
}

variable "ecs_service_name" {
  type = string
  description = "Name of the ECS service"
}
variable "blue_target_group_name" {
  type = string
  description = "Blue target group name"
}

variable "green_target_group_name" {
    type = string
  description = "Green target group name"
}


variable "prod_listener_arn" {
  type = string
  description = "prod listener arn"
}

# variable "test_listener_arn" {
#   type = string
#   description = "test listener arn"
# }