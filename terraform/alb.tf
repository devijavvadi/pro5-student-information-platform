#####################################
# Application Load Balancer
#####################################

resource "aws_lb" "student_alb" {

  name               = "student-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb_sg.id
  ]

  subnets = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]

  tags = {
    Name = "student-alb"
  }
}

#####################################
# Target Group
#####################################

resource "aws_lb_target_group" "student_tg" {

  name     = "student-tg"
  port     = 8080
  protocol = "HTTP"

  vpc_id = aws_vpc.main.id

  target_type = "instance"

  health_check {

    enabled = true

    path = "/studentapp"

    protocol = "HTTP"

    port = "traffic-port"

    interval = 30

    timeout = 5

    healthy_threshold = 2

    unhealthy_threshold = 2

    matcher = "200"
  }

  tags = {
    Name = "student-target-group"
  }
}

#####################################
# HTTP Listener
#####################################

resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.student_alb.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.student_tg.arn
  }
}