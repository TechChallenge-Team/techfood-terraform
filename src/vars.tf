variable "projectName" {
  default = "techfood"
}

variable "principal_user_arn" {
  description = "The ARN of the principal user"
}

variable "eks_lab_role_arn" {
  description = "The ARN of the EKS lab role"
}

variable "region_default" {
  default = "us-east-1"
}

variable "cidr_vpc" {
  default = "10.0.0.0/16"
}

variable "instance_type" {
  default = "t3.medium"
}

variable "tags" {
  default = {
    Name        = "techfood",
    School      = "FIAP",
    Environment = "Production",
    Year        = "2025"
  }
}

# RDS SQL Server variables
variable "rds_instance_class" {
  description = "The instance type of the RDS instance"
  default     = "db.t3.micro" # Free tier eligible for AWS Academy
}

variable "rds_allocated_storage" {
  description = "The allocated storage in gibibytes"
  default     = 20
}

variable "rds_max_allocated_storage" {
  description = "The upper limit for automatic storage scaling"
  default     = 50
}

variable "rds_username" {
  description = "Username for the master DB user"
  sensitive   = true
}

variable "rds_password" {
  description = "Password for the master DB user"
  sensitive   = true
}

variable "rds_publicly_accessible" {
  description = "Bool to control if instance is publicly accessible"
  default     = true
}

variable "rds_backup_retention_period" {
  description = "The days to retain backups for"
  default     = 7
}
