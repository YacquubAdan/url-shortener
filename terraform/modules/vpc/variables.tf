variable "vpc_cidr" {
  type        = string
  description = "The CIDR of main vpc"
  default     = "10.0.0.0/16"
}

variable "private_cidrs" {
  type = map(string)
  default = {
    "1" = "10.0.10.0/24",
    "2" = "10.0.11.0/24"
  }
}

variable "public_cidrs" {
  type = map(string)
  default = {
    "1" = "10.0.1.0/24",
    "2" = "10.0.2.0/24",
  }
}