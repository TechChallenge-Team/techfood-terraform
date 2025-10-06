# ================================================================================
# VPC LINK PARA API GATEWAY
# ================================================================================
# VPC Link permite que o API Gateway se conecte com recursos dentro da VPC
# Conecta o API Gateway ao Network Load Balancer que está na VPC
# ================================================================================

resource "aws_apigatewayv2_vpc_link" "vpc_link" {
  name               = "${var.projectName}-vpc-link"
  security_group_ids = [aws_security_group.eks_sg.id]
  subnet_ids         = [for subnet in aws_subnet.public_subnet : subnet.id]

  tags = merge(var.tags, {
    Name = "${var.projectName}-vpc-link"
  })
}
