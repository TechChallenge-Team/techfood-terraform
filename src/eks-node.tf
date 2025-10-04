# ================================================================================
# LAUNCH TEMPLATE PARA OS NODES
# ================================================================================

resource "aws_launch_template" "eks_nodes" {
  name_prefix            = "${var.projectName}-node-"
  update_default_version = true

  vpc_security_group_ids = [aws_security_group.eks_sg.id]

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 50
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.tags, {
      Name = "${var.projectName}-eks-node"
    })
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ================================================================================
# EKS NODE GROUP
# ================================================================================

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.projectName}-nodeg"
  node_role_arn   = var.eks_lab_role_arn
  subnet_ids      = aws_subnet.public_subnet[*].id
  instance_types  = [var.instance_type]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = "$Latest"
  }

  # depends_on removido pois usamos roles pré-existentes do AWS Academy com policies já anexadas
  # depends_on = [
  #   aws_iam_role_policy_attachment.node-AmazonEKSWorkerNodePolicy,
  #   aws_iam_role_policy_attachment.node-AmazonEKS_CNI_Policy,
  #   aws_iam_role_policy_attachment.node-AmazonEC2ContainerRegistryReadOnly,
  # ]
}
