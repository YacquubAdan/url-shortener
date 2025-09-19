resource "aws_lb" "main_lb" {
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.lb_sg_id]
  subnets                    = values(var.public_subnet_ids)
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "blue" {
  name        = "blue-target-group"
  port        = "8080"
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/healthz"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "green" {
  name        = "green-target-group"
  port        = "8080"
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/healthz"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "production" {
  load_balancer_arn = aws_lb.main_lb.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
}

resource "aws_lb_listener_rule" "prod_listener_rule" {
  listener_arn = aws_lb_listener.production.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}
resource "aws_lb_listener" "test" {
  load_balancer_arn = aws_lb.main_lb.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green.arn
  }
}
resource "aws_lb_listener_rule" "test_listener_rule" {
  listener_arn = aws_lb_listener.test.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green.arn
  }
  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}