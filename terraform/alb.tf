resource "aws_lb" "application_load_balancer" {
  name = "application-load-balancer"
  internal = false
  load_balancer_type = "application"
  subnets = [aws_subnet.alb_public_subnet.id]
}

resource "aws_security_group" "alb_security_group" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = [ "::/0" ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = [ "::/0" ]
  }

  tags = {
    Name = "alb-securrity-group"
  }
}
