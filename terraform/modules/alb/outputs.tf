output "load_balancer_arn" {
  value = aws_lb.main_lb.arn
}

output "green_target_group_name" {
  value = aws_lb_target_group.green.name

}
output "blue_target_group_name" {
  value = aws_lb_target_group.blue.name

}
output "blue_target_group_arn" {
  value = aws_lb_target_group.blue.arn
}
output "load_balancer_dns_name" {
  value = aws_lb.main_lb.dns_name
}

output "prod_listener_arn" {
  value = aws_lb_listener.production.arn
}
output "test_listener_arn" {
  value = aws_lb_listener.test.arn
}