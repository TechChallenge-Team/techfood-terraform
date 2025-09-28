output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_cidr" {
  value = aws_subnet.subnet_public[*].cidr_block
}

output "subnet_id" {
  value = aws_subnet.subnet_public[*].id
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

output "efs_file_system_id" {
  description = "ID do EFS para usar em PersistentVolumes"
  value = aws_efs_file_system.efs.id
}

output "efs_dns_name" {
  description = "DNS do EFS para configuração de PV"
  value = aws_efs_file_system.efs.dns_name
}

# ================================================================================
# OUTPUTS DO RDS SQL SERVER
# ================================================================================

output "rds_endpoint" {
  description = "RDS SQL Server endpoint"
  value       = aws_db_instance.sqlserver.endpoint
  sensitive   = true
}

output "rds_identifier" {
  description = "RDS instance identifier"
  value       = aws_db_instance.sqlserver.identifier
}

output "rds_port" {
  description = "RDS SQL Server port"
  value       = aws_db_instance.sqlserver.port
}

output "rds_username" {
  description = "RDS master username"
  value       = aws_db_instance.sqlserver.username
  sensitive   = true
}
