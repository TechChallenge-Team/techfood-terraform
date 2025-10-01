# ================================================================================
# AUTO-REGISTRO DOS NÓS DO EKS NO TARGET GROUP DO NLB
# ================================================================================
# Este recurso garante que os worker nodes do EKS sejam automaticamente
# registrados no Target Group do NLB, permitindo que o tráfego do API Gateway
# chegue ao Nginx Ingress Controller rodando nos nós via hostNetwork.
# ================================================================================
# Data source para obter as instâncias EC2 dos worker nodes do EKS
data "aws_instances" "eks_nodes" {
  filter {
    name   = "tag:eks:cluster-name"
    values = [aws_eks_cluster.cluster.name]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }

  depends_on = [aws_eks_node_group.node_group]
}

# Registra automaticamente as instâncias dos worker nodes no Target Group
resource "aws_lb_target_group_attachment" "eks_nodes" {
  count = length(data.aws_instances.eks_nodes.ids)

  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = data.aws_instances.eks_nodes.ids[count.index]
  port             = 30488

  depends_on = [
    aws_eks_node_group.node_group,
    aws_lb_target_group.tg
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# ================================================================================
# OUTPUT PARA VERIFICAÇÃO
# ================================================================================
output "registered_worker_node_ids" {
  description = "IDs dos worker nodes registrados no Target Group"
  value       = data.aws_instances.eks_nodes.ids
}

output "registered_worker_node_ips" {
  description = "IPs privados dos worker nodes registrados"
  value       = data.aws_instances.eks_nodes.private_ips
}