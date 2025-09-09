output "load_balancer_arn" {
  value = aws_lb.main_lb.arn
}


output "target_group_arn" {
  value = aws_lb_target_group.lb_target.arn
}

output "load_balancer_dns_name" {
  value = aws_lb.main_lb.dns_name
}