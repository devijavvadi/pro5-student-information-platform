variable "key_pair_name" {
  description = "AWS Key Pair Name"
  type        = string
}

variable "db_username" {
  description = "RDS Admin Username"
  type        = string
}

variable "db_password" {
  description = "RDS Admin Password"
  type        = string
  sensitive   = true
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}