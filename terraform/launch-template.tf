########################################
# Latest Amazon Linux 2023 AMI
########################################

data "aws_ami" "amazon_linux" {

  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

########################################
# Launch Template
########################################

resource "aws_launch_template" "student_lt" {

  name_prefix   = "student-app-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  key_name = var.key_pair_name

  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  user_data = base64encode(file("${path.module}/userdata.sh"))

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "student-app-server"
    }
  }
}