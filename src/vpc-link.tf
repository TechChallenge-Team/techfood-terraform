# ================================================================================
# VPC LINK PARA API GATEWAY
# ================================================================================
# VPC Link permite que o API Gateway se conecte com recursos dentro da VPC
# Conecta o API Gateway ao Network Load Balancer que está na VPC
# ================================================================================

resource "aws_api_gateway_vpc_link" "vpc_link" {
  name        = "${var.projectName}-vpc-link"
  description = "VPC Link to connect API Gateway to NLB"
  target_arns = [aws_lb.nlb.arn]

  tags = var.tags
}

# ================================================================================
# NETWORK LOAD BALANCER
# ================================================================================
# Network Load Balancer interno para rotear tráfego do API Gateway para o EKS
# ================================================================================

resource "aws_lb" "nlb" {
  name               = "${var.projectName}-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets = [
    aws_subnet.subnet_public[0].id,
    aws_subnet.subnet_public[1].id,
    aws_subnet.subnet_public[2].id
  ]

  enable_deletion_protection = false

  tags = var.tags
}

# Target Group para o NLB
resource "aws_lb_target_group" "tg" {
  name     = "${var.projectName}-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.vpc.id

  target_type = "instance"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/api/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = var.tags
}

# Listener para o NLB
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
