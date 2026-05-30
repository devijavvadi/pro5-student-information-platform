########################################
# RDS Subnet Group
########################################

resource "aws_db_subnet_group" "student_db_subnet_group" {

  name        = "student-db-subnet-group"
  description = "Subnet group for Student MySQL RDS"

  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  tags = {
    Name = "student-db-subnet-group"
  }
}

########################################
# RDS Security Group
########################################

resource "aws_security_group" "rds_sg" {

  name        = "student-rds-sg"
  description = "Allow MySQL access from EC2 instances"
  vpc_id      = aws_vpc.main.id

  ingress {

    description = "MySQL from EC2"

    from_port = 3306
    to_port   = 3306

    protocol = "tcp"

    security_groups = [
      aws_security_group.ec2_sg.id
    ]
  }

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "student-rds-sg"
  }
}

########################################
# MySQL RDS Instance
########################################

resource "aws_db_instance" "student_db" {

  identifier = "student-db"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = "db.t3.micro"

  allocated_storage     = 20
  max_allocated_storage = 100

  storage_type = "gp3"

  db_name = "studentdb"

  username = var.db_username
  password = var.db_password

  port = 3306

  db_subnet_group_name = aws_db_subnet_group.student_db_subnet_group.name

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]

  publicly_accessible = false

  multi_az = false

  backup_retention_period = 7

  deletion_protection = false

  skip_final_snapshot = true

  auto_minor_version_upgrade = true

  apply_immediately = true

  tags = {
    Name        = "student-mysql-rds"
    Environment = "dev"
    Project     = "student-information-app"
  }
}

