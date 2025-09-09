output "vpc_id" {
  value = aws_vpc.main_vpc.id

}

output "ecs_sg_id" {
  value = aws_security_group.ecs_sg.id

}

output "lb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "public_subnet_ids" {
  value = { for k, v in aws_subnet.public_subnet : k => v.id }

}

output "private_subnet_ids" {
  value = { for k, v in aws_subnet.private_subnet : k => v.id }
}
