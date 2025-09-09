resource "aws_lb" "main_lb" {
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.lb_sg_id]
  subnets                    = values(var.public_subnet_ids)
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "lb_target" {
  port        = "8080"
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "lb_listen" {
  load_balancer_arn = aws_lb.main_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target.arn
  }
}