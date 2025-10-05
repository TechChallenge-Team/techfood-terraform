# ================================================================================
# APPLICATION LOAD BALANCER para API Gateway HTTP API v2
# ================================================================================

resource "aws_lb" "alb" {
  name               = "${var.projectName}-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.eks_sg.id]
  subnets            = [for subnet in aws_subnet.public_subnet : subnet.id]

  enable_deletion_protection = false

  tags = merge(var.tags, {
    Name = "${var.projectName}-alb"
  })
}

# Target Group para o ALB
resource "aws_lb_target_group" "alb_tg" {
  name     = "${var.projectName}-alb-tg"
  port     = 30080
  protocol = "HTTP"
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
    Name = "${var.projectName}-alb-tg"
  })
}

# Listener para o ALB
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

