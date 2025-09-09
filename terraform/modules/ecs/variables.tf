variable "private_subnet_ids" {
  type        = map(string)
  description = "The subnets Ids for the Alb"
}

variable "ecs_sg_id" {
  type        = string
  description = "ECS security group Id"

}

variable "target_group_arn" {
  type        = string
  description = "Target group ARN"
}

variable "task_role_arn" {
  type        = string
  description = "ECS task role ARN"

}
variable "exec_role_arn" {
  type        = string
  description = "ECS execution role ARN"

}

variable "container_name" {
  type        = string
  description = "Name of the application container"
  default     = "url-shortener"
}

variable "container_port" {
  type        = number
  description = "Port the container exposes"
  default     = 8080
}

variable "aws_region" {
  type        = string
  description = "AWS region for deployment"
  default     = "eu-north-1"
}

variable "dynamodb_table_name" {
  type        = string
  description = "Name of the DynamoDB table"
  default     = "yacquub-url-shortener-table"
}

variable "image_tag" {
  type        = string
  description = "Docker image tag to deploy"
  default     = "latest"
}

variable "ecr_repository_name" {
  type        = string
  description = "ecr repo name"

}