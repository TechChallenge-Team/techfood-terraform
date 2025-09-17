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
  description = "Endpoint do cluster EKS"
  value       = aws_eks_cluster.cluster.endpoint
}

output "eks_cluster_name" {
  description = "Nome do cluster EKS"
  value       = aws_eks_cluster.cluster.name
}

output "eks_cluster_arn" {
  description = "ARN do cluster EKS"
  value       = aws_eks_cluster.cluster.arn
}

# ================================================================================
# OUTPUTS DO API GATEWAY
# ================================================================================

output "api_gateway_url" {
  description = "URL base do API Gateway"
  value       = "https://${aws_api_gateway_rest_api.api-gateway.id}.execute-api.${var.region_default}.amazonaws.com/${aws_api_gateway_stage.prod.stage_name}"
}

output "api_gateway_id" {
  description = "ID do API Gateway"
  value       = aws_api_gateway_rest_api.api-gateway.id
}

output "api_gateway_health_url" {
  description = "URL do health check do API Gateway"
  value       = "https://${aws_api_gateway_rest_api.api-gateway.id}.execute-api.${var.region_default}.amazonaws.com/${aws_api_gateway_stage.prod.stage_name}/health"
}

# ================================================================================
# OUTPUTS DO LOAD BALANCER
# ================================================================================

output "nlb_dns_name" {
  description = "DNS name do Network Load Balancer"
  value       = aws_lb.nlb.dns_name
}

output "nlb_arn" {
  description = "ARN do Network Load Balancer"
  value       = aws_lb.nlb.arn
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
