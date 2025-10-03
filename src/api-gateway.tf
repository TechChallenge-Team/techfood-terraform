# ================================================================================
# API GATEWAY - REST API
# ================================================================================
resource "aws_api_gateway_rest_api" "api-gateway" {
  name        = "${var.projectName}-api-gateway"
  description = "API Gateway service"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = merge(var.tags, {
    Name = "${var.projectName}-api-gateway"
  })
}

# Recurso principal da API (/api)
resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_rest_api.api-gateway.root_resource_id
  path_part   = "api"
}

# Proxy resource para capturar todas as rotas (/api/{proxy+})
resource "aws_api_gateway_resource" "proxy_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_resource.api_resource.id
  path_part   = "{proxy+}"
}

# ================================================================================
# MÉTODOS DO API GATEWAY
# ================================================================================

# Método ANY para o proxy (captura todos os métodos HTTP)
resource "aws_api_gateway_method" "proxy_any" {
  rest_api_id   = aws_api_gateway_rest_api.api-gateway.id
  resource_id   = aws_api_gateway_resource.proxy_resource.id
  http_method   = "ANY"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

# Método ANY para o recurso /api
resource "aws_api_gateway_method" "api_any" {
  rest_api_id   = aws_api_gateway_rest_api.api-gateway.id
  resource_id   = aws_api_gateway_resource.api_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

# ================================================================================
# INTEGRAÇÕES DO API GATEWAY
# ================================================================================

# Integração do proxy via VPC Link (conecta com o EKS)
resource "aws_api_gateway_integration" "proxy_integration" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  resource_id = aws_api_gateway_resource.proxy_resource.id
  http_method = aws_api_gateway_method.proxy_any.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = "http://${aws_lb.nlb.dns_name}/{proxy}"
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.vpc_link.id

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

# Integração do recurso /api via VPC Link
resource "aws_api_gateway_integration" "api_integration" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = aws_api_gateway_method.api_any.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = "http://${aws_lb.nlb.dns_name}/"
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.vpc_link.id
}


# ================================================================================
# DEPLOYMENT E STAGE
# ================================================================================

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id

  depends_on = [
    aws_api_gateway_method.proxy_any,
    aws_api_gateway_method.api_any,
    aws_api_gateway_integration.proxy_integration,
    aws_api_gateway_integration.api_integration,
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api-gateway.id
  stage_name    = "prod"

  tags = merge(var.tags, {
    Name = "${var.projectName}-api-gateway-stage"
  })
}
