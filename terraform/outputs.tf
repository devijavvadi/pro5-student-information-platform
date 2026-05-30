########################################
# ALB DNS
########################################

output "alb_dns_name" {
  description = "Application Load Balancer DNS Name"
  value       = aws_lb.student_alb.dns_name
}

########################################
# RDS Endpoint
########################################

output "rds_endpoint" {
  description = "RDS Endpoint"
  value       = aws_db_instance.student_db.endpoint
}

########################################
# RDS Database Name
########################################

output "rds_database_name" {
  description = "Database Name"
  value       = aws_db_instance.student_db.db_name
}

