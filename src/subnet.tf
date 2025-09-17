resource "aws_subnet" "subnet_public" {
  count                   = 3
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 4, count.index)
  map_public_ip_on_launch = true
  availability_zone       = ["us-east-1a", "us-east-1b", "us-east-1c"][count.index]

  tags = var.tags
}

# DB Subnet Group for SQL Server RDS
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.projectName}-db-subnet-group"
  subnet_ids = [for subnet in aws_subnet.subnet_public : subnet.id]

  tags = merge(var.tags, {
    Name = "${var.projectName}-db-subnet-group"
  })
}
