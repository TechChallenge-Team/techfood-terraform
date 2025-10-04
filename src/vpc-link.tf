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

  tags = merge(var.tags, {
    Name = "${var.projectName}-vpc-link"
  })
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
  subnets = [for subnet in aws_subnet.public_subnet : subnet.id]

  enable_deletion_protection = false

  tags = merge(var.tags, {
    Name = "${var.projectName}-nlb"
  })
}

# Target Group para o NLB
resource "aws_lb_target_group" "tg" {
  name     = "${var.projectName}-tg"
  port     = 30080
  protocol = "TCP"
  vpc_id   = aws_vpc.vpc.id

  target_type = "instance"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    path                = "/api/health"
    port                = "30080"
    protocol            = "HTTP"
    timeout             = 10
    unhealthy_threshold = 2
  }

  tags = merge(var.tags, {
    Name = "${var.projectName}-tg"
  })
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
