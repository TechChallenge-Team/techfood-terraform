resource "aws_security_group" "eks_sg" {
  name        = "${var.projectName}-sg"
  description = "Security group for EKS nodes"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "efs_sg" {
  name_prefix = "${var.projectName}-efs-sg"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.projectName}-efs-sg"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.projectName}-rds-sg"
  description = "Security group for RDS SQL Server"
  vpc_id      = aws_vpc.vpc.id

  # Acesso interno do EKS
  ingress {
    from_port       = 1433
    to_port         = 1433
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_sg.id]
    description     = "SQL Server access from EKS nodes"
  }

  # Acesso externo (da internet)
  ingress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SQL Server access from internet"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.projectName}-rds-sg"
  })
}
