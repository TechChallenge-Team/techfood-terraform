# Access entries não são necessários no AWS Academy pois a role voclabs já tem permissões

# resource "aws_eks_access_entry" "access_entry" {
#   cluster_name      = aws_eks_cluster.cluster.name
#   principal_arn     = data.aws_iam_user.principal_user.arn
#   kubernetes_groups = ["techfood-group"]
#   type              = "STANDARD"
# }

# resource "aws_eks_access_policy_association" "access_entry_association" {
#   cluster_name  = aws_eks_cluster.cluster.name
#   policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
#   principal_arn = data.aws_iam_user.principal_user.arn

#   access_scope {
#     type = "cluster"
#   }
# }
