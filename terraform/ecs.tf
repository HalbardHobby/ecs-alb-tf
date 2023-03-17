resource "aws_ecs_cluster" "aws_ecs_cluster" {
  name = "sample_cluster"
  tags = {
    Name = "sample_cluster"
  }
}


