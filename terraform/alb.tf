resource "aws_lb" "application_load_balancer" {
  name               = "application-load-balancer"
  internal           = false
  load_balancer_type = "application"
  subnets = [aws_subnet.alb_public_subnet_1.id,
  aws_subnet.alb_public_subnet_2.id]
}

resource "aws_security_group" "alb_security_group" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "alb-securrity-group"
  }
}

resource "aws_lb_target_group" "target_group" {
  name = "alb-target-group"
  port = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = aws_vpc.main.id

  health_check {
    healthy_threshold = "3"
    interval = "300"
    protocol = "HTTP"
    matcher = "200"
    timeout = "3"
    path = "/v1/status"
    unhealthy_threshold = "2"
  }

  tags = {
    "Name" = "alb-target-group"
  }
}

resource "aws_alb_listener" "listener" {
  load_balancer_arn = aws_lb.application_load_balancer.id
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }
}
