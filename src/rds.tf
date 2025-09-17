# RDS SQL Server instance
resource "aws_db_instance" "sqlserver" {
  identifier = "${var.projectName}-sqlserver"

  # SQL Server configuration
  engine         = "sqlserver-ex"
  engine_version = "15.00.4236.7.v1" # SQL Server 2019 Express
  instance_class = var.rds_instance_class

  # Storage configuration - optimized for AWS Academy
  allocated_storage     = var.rds_allocated_storage
  max_allocated_storage = var.rds_max_allocated_storage
  storage_type          = "gp2"
  storage_encrypted     = false # Disabled for AWS Academy compatibility

  # Database configuration
  # Note: db_name is not supported for SQL Server Express
  username = var.rds_username
  password = var.rds_password
  port     = 1433

  # Network configuration
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = var.rds_publicly_accessible

  # Backup and maintenance configuration - optimized for AWS Academy
  backup_retention_period = var.rds_backup_retention_period
  backup_window           = "03:00-04:00"
  maintenance_window      = "sun:04:00-sun:05:00"

  # Performance and monitoring
  performance_insights_enabled = false # Disabled for cost optimization
  monitoring_interval          = 0     # Disabled for AWS Academy

  # Deletion protection - disabled for development/learning environment
  deletion_protection = false
  skip_final_snapshot = true

  # License model for SQL Server Express
  license_model = "license-included"

  # Character set (not applicable for SQL Server)
  # character_set_name = "SQL_Latin1_General_CP1_CI_AS"

  tags = merge(var.tags, {
    Name   = "${var.projectName}-sqlserver"
    Type   = "RDS"
    Engine = "SQL Server Express"
  })

  depends_on = [
    aws_db_subnet_group.db_subnet_group,
    aws_security_group.rds_sg
  ]
}
