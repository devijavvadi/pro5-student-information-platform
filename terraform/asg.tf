########################################
# Auto Scaling Group
########################################

resource "aws_autoscaling_group" "student_asg" {

  name = "student-asg"

  desired_capacity = 2
  min_size         = 2
  max_size         = 4

  vpc_zone_identifier = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]

  launch_template {
    id      = aws_launch_template.student_lt.id
    version = "$Latest"
  }

  target_group_arns = [
    aws_lb_target_group.student_tg.arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  force_delete = true

  tag {
    key                 = "Name"
    value               = "student-app-server"
    propagate_at_launch = true
  }
}

########################################
# Target Tracking Scaling Policy
########################################

resource "aws_autoscaling_policy" "cpu_target" {

  name                   = "student-cpu-target"
  autoscaling_group_name = aws_autoscaling_group.student_asg.name

  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {

    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}