########################################
# Auto Scaling Group
########################################

resource "aws_autoscaling_group" "student_asg" {

  name = "student-asg"

  desired_capacity = 2
  min_size         = 2
  max_size         = 4

  vpc_zone_identifier = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  launch_template {
    id      = aws_launch_template.student_lt.id
    version = "$Latest"
  }

  target_group_arns = [
    aws_lb_target_group.student_tg.arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 120

  force_delete = true

  tag {
    key                 = "Name"
    value               = "student-app-server"
    propagate_at_launch = true
  }
}