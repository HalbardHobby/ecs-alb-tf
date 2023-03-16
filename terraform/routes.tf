resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private_alb_table"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_alb_table"
  }
}

resource "aws_route_table_association" "private_alb" {
  subnet_id = aws_subnet.alb_private_subnet.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public_alb" {
  subnet_id = aws_subnet.alb_public_subnet.id
  route_table_id = aws_route_table.public.id
}
