# ================================================================================
# EKS ADDONS
# ================================================================================
# Addons essenciais para o funcionamento do cluster EKS
# ================================================================================

# EBS CSI Driver - Necessário para PersistentVolumes EBS
# Versão simplificada para AWS Academy (sem IAM roles customizadas)
resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name = aws_eks_cluster.cluster.name
  addon_name   = "aws-ebs-csi-driver"
  
  depends_on = [aws_eks_node_group.node_group]

  tags = merge(var.tags, {
    Name = "${var.projectName}-ebs-csi-driver"
  })
}

# EFS CSI Driver - Para usar EFS como storage (melhor para AWS Academy)
resource "aws_eks_addon" "efs_csi_driver" {
  cluster_name = aws_eks_cluster.cluster.name
  addon_name   = "aws-efs-csi-driver"
  
  depends_on = [aws_eks_node_group.node_group]

  tags = merge(var.tags, {
    Name = "${var.projectName}-efs-csi-driver"
  })
}

# CoreDNS addon (já incluído por padrão, mas vamos gerenciar explicitamente)
resource "aws_eks_addon" "coredns" {
  cluster_name  = aws_eks_cluster.cluster.name
  addon_name    = "coredns"
  addon_version = "v1.11.3-eksbuild.2"  # Versão compatível com EKS 1.31
  
  depends_on = [aws_eks_node_group.node_group]

  tags = merge(var.tags, {
    Name = "${var.projectName}-coredns"
  })
}

# VPC CNI addon
resource "aws_eks_addon" "vpc_cni" {
  cluster_name  = aws_eks_cluster.cluster.name
  addon_name    = "vpc-cni"
  addon_version = "v1.19.0-eksbuild.1"  # Versão compatível com EKS 1.31
  
  depends_on = [aws_eks_node_group.node_group]

  tags = merge(var.tags, {
    Name = "${var.projectName}-vpc-cni"
  })
}

# Kube-proxy addon
resource "aws_eks_addon" "kube_proxy" {
  cluster_name  = aws_eks_cluster.cluster.name
  addon_name    = "kube-proxy"
  addon_version = "v1.31.2-eksbuild.3"  # Versão compatível com EKS 1.31
  
  depends_on = [aws_eks_node_group.node_group]

  tags = merge(var.tags, {
    Name = "${var.projectName}-kube-proxy"
  })
}