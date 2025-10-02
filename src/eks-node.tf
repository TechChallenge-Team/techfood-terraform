resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.projectName}-nodeg"
  node_role_arn   = var.eks_lab_role_arn
  subnet_ids      = aws_subnet.subnet_public[*].id
  disk_size       = 50
  instance_types  = [var.instance_type]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  # Usar o mesmo security group do cluster
  remote_access {
    source_security_group_ids = [aws_security_group.eks_sg.id]
  }

  # depends_on removido pois usamos roles pré-existentes do AWS Academy com policies já anexadas
  # depends_on = [
  #   aws_iam_role_policy_attachment.node-AmazonEKSWorkerNodePolicy,
  #   aws_iam_role_policy_attachment.node-AmazonEKS_CNI_Policy,
  #   aws_iam_role_policy_attachment.node-AmazonEC2ContainerRegistryReadOnly,
  # ]
}
