variable "vpc_id" {
  type        = string
  description = "The ID of VPC"

}


variable "lb_sg_id" {
  type        = string
  description = "The lb security group ID"
}


variable "public_subnet_ids" {
  type        = map(string)
  description = "The subnets Ids for the Alb"
}