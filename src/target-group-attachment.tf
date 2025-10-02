# ================================================================================
# AUTO-REGISTRO DOS NÓS DO EKS NO TARGET GROUP DO NLB
# ================================================================================
# Este recurso garante que os worker nodes do EKS sejam automaticamente
# registrados no Target Group do NLB, permitindo que o tráfego do API Gateway
# chegue ao Nginx Ingress Controller rodando nos nós via hostNetwork.
# ================================================================================
# IMPORTANTE: Esta abordagem usa aws_autoscaling_attachment que é a forma
# recomendada para integrar Auto Scaling Groups (criados pelo EKS Node Group)
# com Target Groups do Load Balancer. Isso garante que novos nodes sejam
# automaticamente registrados e nodes removidos sejam desregistrados.
# ================================================================================

# Data source para obter o Auto Scaling Group criado pelo EKS Node Group
data "aws_autoscaling_groups" "eks_node_groups" {
  filter {
    name   = "tag:eks:cluster-name"
    values = [aws_eks_cluster.cluster.name]
  }

  filter {
    name   = "tag:eks:nodegroup-name"
    values = [aws_eks_node_group.node_group.node_group_name]
  }

  depends_on = [aws_eks_node_group.node_group]
}

# Anexa o Auto Scaling Group do EKS ao Target Group do NLB
# Isso garante que todas as instâncias do ASG sejam automaticamente registradas
resource "aws_autoscaling_attachment" "eks_nodes_to_nlb" {
  autoscaling_group_name = data.aws_autoscaling_groups.eks_node_groups.names[0]
  lb_target_group_arn    = aws_lb_target_group.tg.arn

  depends_on = [
    aws_eks_node_group.node_group,
    aws_lb_target_group.tg
  ]
}