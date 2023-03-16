resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    name = "ecs_main"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "ecs_igw"
  }
}

resource "aws_subnet" "alb_public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 1)
  map_public_ip_on_launch = true

  tags = {
    "Name" = "alb_public_subnet"
  }
}

resource "aws_subnet" "alb_private_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 6)
  map_public_ip_on_launch = false

    tags = {
    "Name" = "alb_private_subnet"
  }
}

resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "alb_nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.alb_public_subnet.id

  tags = {
    Name = "alb_nat"
  }

  depends_on = [
    aws_internet_gateway.igw
  ]
}
