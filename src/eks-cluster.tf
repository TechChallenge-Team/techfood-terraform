resource "aws_eks_cluster" "cluster" {
  name = "${var.projectName}-eks"

  access_config {
    authentication_mode = "API"
  }

  role_arn = var.eks_lab_role_arn
  version  = "1.31"

  vpc_config {
    subnet_ids = [
      aws_subnet.subnet_public[0].id,
      aws_subnet.subnet_public[1].id,
      aws_subnet.subnet_public[2].id
    ]
    security_group_ids = [aws_security_group.sg.id]
  }

  # depends_on removido pois usamos roles pré-existentes do AWS Academy
  # depends_on = [
  #   aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  # ]
}
