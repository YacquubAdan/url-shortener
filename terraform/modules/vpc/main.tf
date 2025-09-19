resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "yacquubs-main-vpc"
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "yacquub-igw"
  }
}

resource "aws_subnet" "public_subnet" {
  for_each = var.public_cidrs
  vpc_id   = aws_vpc.main_vpc.id

  cidr_block        = each.value
  availability_zone = each.key == "1" ? "eu-north-1a" : "eu-north-1b"

  tags = {
    Name = "yacquub-public-subnet-${each.key}"
  }
}

resource "aws_subnet" "private_subnet" {
  for_each          = var.private_cidrs
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = each.value
  availability_zone = each.key == "1" ? "eu-north-1a" : "eu-north-1b"

  tags = {
    Name = "yacquub-private-subnet-${each.key}"
  }
}


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "yacquub-public-rt"
  }
}

resource "aws_route_table_association" "public_rt_association" {
  for_each       = aws_subnet.public_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "private_rt_association" {
  for_each       = aws_subnet.private_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}


resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_vpc_endpoint" "db_endpoint" {
  vpc_id            = aws_vpc.main_vpc.id
  service_name      = "com.amazonaws.eu-north-1.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private_rt.id]
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = aws_vpc.main_vpc.id
  service_name        = "com.amazonaws.eu-north-1.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [for s in aws_subnet.private_subnet : s.id]
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.endpoint_sg.id]

}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = aws_vpc.main_vpc.id
  service_name        = "com.amazonaws.eu-north-1.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [for s in aws_subnet.private_subnet : s.id]
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.endpoint_sg.id]
}

resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id            = aws_vpc.main_vpc.id
  service_name      = "com.amazonaws.eu-north-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private_rt.id]
}

resource "aws_vpc_endpoint" "logs" {
  vpc_id              = aws_vpc.main_vpc.id
  service_name        = "com.amazonaws.eu-north-1.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [for s in aws_subnet.private_subnet : s.id]
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.endpoint_sg.id]
}


resource "aws_security_group" "alb_sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main_vpc.id

  tags = {
    Name = "alb security group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.alb_sg.id
  from_port         = "80"
  ip_protocol       = "tcp"
  to_port           = "80"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "allow_test_port" {
  security_group_id = aws_security_group.alb_sg.id
  from_port         = "8080"
  ip_protocol       = "tcp"
  to_port           = "8080"
  cidr_ipv4         = "0.0.0.0/0"
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


resource "aws_security_group" "ecs_sg" {
  name   = "app security group"
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "yacquub-app-sg"
  }

} 

resource "aws_vpc_security_group_ingress_rule" "app_ingress" {
  security_group_id            = aws_security_group.ecs_sg.id
  ip_protocol                  = "tcp"
  from_port                    = "8080"
  to_port                      = "8080"
  referenced_security_group_id = aws_security_group.alb_sg.id
}

resource "aws_vpc_security_group_egress_rule" "app_egress" {
  security_group_id = aws_security_group.ecs_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

}


resource "aws_security_group" "endpoint_sg" {
  name   = "endpoint security group"
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "yacquub-endpoint-sg"
  }

}

resource "aws_vpc_security_group_ingress_rule" "endpoint_ingress" {
  security_group_id            = aws_security_group.endpoint_sg.id
  ip_protocol                  = "tcp"
  from_port                    = "0"
  to_port                      = "65535"
  referenced_security_group_id = aws_security_group.ecs_sg.id
  description                  = "Allow all TCP traffic from ECS security group"
}

resource "aws_vpc_security_group_egress_rule" "endpoint_egress" {
  security_group_id = aws_security_group.endpoint_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

}

