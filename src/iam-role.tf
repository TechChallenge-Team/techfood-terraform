# Usando roles pré-existentes do AWS Academy
# No AWS Academy, não temos permissão para criar roles IAM, então usamos as existentes
# As policy attachments já estão configuradas nas roles do AWS Academy

# Para obter os nomes corretos das roles, podemos verificar no console do IAM através do link:
# https://console.aws.amazon.com/iam/home?region=us-east-1#/roles

data "aws_iam_role" "cluster" {
  name = "c173096a4485959l11582196t1w767397-LabEksClusterRole-yWlFENQyPCer" # EKS Cluster Role
}

data "aws_iam_role" "node" {
  name = "c173096a4485959l11582196t1w767397785-LabEksNodeRole-Mglan1i62zKz" # EKS Node Group Role
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
