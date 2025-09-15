# ================================================================================
# IAM ROLES PARA EKS - AWS ACADEMY
# ================================================================================
# No AWS Academy, não temos permissão para criar roles IAM personalizadas.
# Utilizamos as roles pré-criadas que seguem o padrão do AWS Academy.
# 
# Estrutura do nome das roles:
# - c173096a4485959l11582196t1w767397: ID único do laboratório AWS Academy
# - LabEksClusterRole / LabEksNodeRole: Função específica da role
# - Sufixo aleatório: Identificador único gerado pelo CloudFormation
# ================================================================================

# Role para o EKS Control Plane
data "aws_iam_role" "eks_cluster_role" {
  name = "c173096a4485959l11582196t1w767397-LabEksClusterRole-yWlFENQyPCer"
}

# Role para os Worker Nodes do EKS
data "aws_iam_role" "eks_node_group_role" {
  name = "c173096a4485959l11582196t1w767397785-LabEksNodeRole-Mglan1i62zKz"
}

# resource "aws_iam_role" "cluster" {
#   name = "eks-cluster-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "sts:AssumeRole",
#           "sts:TagSession"
#         ]
#         Effect = "Allow"
#         Principal = {
#           Service = "eks.amazonaws.com"
#         }
#       },
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   role       = aws_iam_role.cluster.name
# }

# resource "aws_iam_role" "node" {
#   name = "eks-node-group-role"

#   assume_role_policy = jsonencode({
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "ec2.amazonaws.com"
#       }
#     }]
#     Version = "2012-10-17"
#   })
# }

# resource "aws_iam_role_policy_attachment" "node-AmazonEKSWorkerNodePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.node.name
# }

# resource "aws_iam_role_policy_attachment" "node-AmazonEKS_CNI_Policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.node.name
# }

# resource "aws_iam_role_policy_attachment" "node-AmazonEC2ContainerRegistryReadOnly" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.node.name
# }
