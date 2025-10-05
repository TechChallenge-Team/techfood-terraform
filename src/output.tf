output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_cidr" {
  value = aws_subnet.public_subnet[*].cidr_block
}

output "subnet_id" {
  value = aws_subnet.public_subnet[*].id
}

# ================================================================================
# OUTPUTS DO EKS CLUSTER
# ================================================================================

output "eks_cluster_endpoint" {
  description = "Cluster EKS endpoint"
  value       = aws_eks_cluster.cluster.endpoint
}

output "eks_cluster_name" {
  description = "Cluster EKS name"
  value       = aws_eks_cluster.cluster.name
}

output "eks_cluster_arn" {
  description = "Cluster EKS ARN"
  value       = aws_eks_cluster.cluster.arn
}

# ================================================================================
# OUTPUTS DO API GATEWAY
# ================================================================================

output "api_gateway_url" {
  description = "API Gateway base URL"
  value       = "https://${aws_api_gateway_rest_api.api-gateway.id}.execute-api.${var.region_default}.amazonaws.com/${aws_api_gateway_stage.prod.stage_name}"
}

output "api_gateway_id" {
  description = "API Gateway ID"
  value       = aws_api_gateway_rest_api.api-gateway.id
}

output "api_gateway_health_url" {
  description = "API Gateway health check URL"
  value       = "https://${aws_api_gateway_rest_api.api-gateway.id}.execute-api.${var.region_default}.amazonaws.com/${aws_api_gateway_stage.prod.stage_name}/health"
}

# ================================================================================
# OUTPUTS DO LOAD BALANCER
# ================================================================================

output "nlb_dns_name" {
  description = "Network Load Balancer DNS name"
  value       = aws_lb.nlb.dns_name
}

output "nlb_arn" {
  description = "Network Load Balancer ARN"
  value       = aws_lb.nlb.arn
}

output "nlb_target_group_arn" {
  description = "Target Group ARN - Use this in NGINX Ingress Controller annotation"
  value       = aws_lb_target_group.tg.arn
}

output "efs_file_system_id" {
  description = "ID do EFS para usar em PersistentVolumes"
  value       = aws_efs_file_system.efs.id
}

output "efs_dns_name" {
  description = "DNS do EFS para configuração de PV"
  value       = aws_efs_file_system.efs.dns_name
}

# ================================================================================
# OUTPUT PARA VERIFICAÇÃO DO AUTO SCALING GROUP E TARGET GROUP
# ================================================================================
output "eks_autoscaling_group_name" {
  description = "Nome do Auto Scaling Group dos worker nodes do EKS"
  value       = try(data.aws_autoscaling_groups.eks_node_groups.names[0], "N/A")
}

output "target_group_arn" {
  description = "ARN do Target Group anexado ao Auto Scaling Group"
  value       = aws_lb_target_group.tg.arn
}

output "nlb_target_group_health" {
  description = "Configuração de health check do Target Group"
  value = {
    protocol            = aws_lb_target_group.tg.health_check[0].protocol
    port                = aws_lb_target_group.tg.health_check[0].port
    path                = aws_lb_target_group.tg.health_check[0].path
    healthy_threshold   = aws_lb_target_group.tg.health_check[0].healthy_threshold
    unhealthy_threshold = aws_lb_target_group.tg.health_check[0].unhealthy_threshold
  }
}

# ================================================================================
# OUTPUTS DOS SECURITY GROUPS
# ================================================================================

output "eks_security_group_id" {
  description = "ID do Security Group do EKS (cluster e nodes)"
  value       = aws_security_group.eks_sg.id
}

output "efs_security_group_id" {
  description = "ID do Security Group do EFS"
  value       = aws_security_group.efs_sg.id
}

# ================================================================================
# OUTPUTS DA LAMBDA DE AUTENTICAÇÃO
# ================================================================================

output "auth_lambda_function_name" {
  value = var.lambda_function_name
  description = "Lambda function name that the pipeline should deploy to"
}

output "auth_lambda_function_arn" {
  value = "arn:aws:lambda:${var.region_default}:${data.aws_caller_identity.current.account_id}:function:${var.lambda_function_name}"
  description = "Full ARN for the Lambda function (useful in CI/CD)"
}

output "auth_api_invoke_url" {
  value = "https://${aws_api_gateway_rest_api.api-gateway.id}.execute-api.${var.region_default}.amazonaws.com/prod/auth"
  description = "Public invoke URL for the Authentication endpoint (stage prod)"
}

output "auth_lambda_artifacts_bucket_name" {
  value       = aws_s3_bucket.lambda_artifacts_bucket.id
  description = "S3 bucket where the CI pipeline should upload the Lambda package"
}