data "aws_ecr_repository" "app" {
  name = var.ecr_repository_name
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/url-shortener"
  retention_in_days = 7
}

resource "aws_ecs_cluster" "app_cluster" {
  name = "yacquub-app-cluster"
}
resource "aws_ecs_task_definition" "app_td" {
  family                   = "url-shortener-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = var.exec_role_arn
  task_role_arn            = var.task_role_arn

  runtime_platform {
    cpu_architecture        = "ARM64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = "${data.aws_ecr_repository.app.repository_url}:${var.image_tag}"
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "DYNAMODB_TABLE"
          value = var.dynamodb_table_name
        },
        {
          name  = "AWS_REGION"
          value = var.aws_region
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/url-shortener"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:${var.container_port}/healthz || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }
    }
  ])
}

resource "aws_ecs_service" "app_service" {
  name            = "app-service"
  cluster         = aws_ecs_cluster.app_cluster.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.app_td.arn


  deployment_controller {
    type = "ECS"
  }
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  network_configuration {
    subnets          = values(var.private_subnet_ids)
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = false
  }

}