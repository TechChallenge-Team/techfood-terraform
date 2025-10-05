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

# Recurso para autenticação (/auth)
resource "aws_api_gateway_resource" "auth" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_rest_api.api-gateway.root_resource_id
  path_part   = "auth"
}

# Proxy resource para capturar todas as outras rotas (/{proxy+})
# Isso captura tudo exceto /auth que já está definido acima
resource "aws_api_gateway_resource" "proxy_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_rest_api.api-gateway.root_resource_id
  path_part   = "{proxy+}"
}

# ================================================================================
# MÉTODOS DO API GATEWAY
# ================================================================================

# Método ANY para o recurso /auth (Lambda)
resource "aws_api_gateway_method" "auth_any" {
  rest_api_id   = aws_api_gateway_rest_api.api-gateway.id
  resource_id   = aws_api_gateway_resource.auth.id
  http_method   = "ANY"
  authorization = "NONE"
}

# Método ANY para o proxy (captura todos os métodos HTTP e direciona para EKS)
resource "aws_api_gateway_method" "proxy_any" {
  rest_api_id   = aws_api_gateway_rest_api.api-gateway.id
  resource_id   = aws_api_gateway_resource.proxy_resource.id
  http_method   = "ANY"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

# ================================================================================
# INTEGRAÇÕES DO API GATEWAY
# ================================================================================

# Integração do recurso /auth com a Lambda de autenticação
resource "aws_api_gateway_integration" "auth_integration" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  resource_id = aws_api_gateway_resource.auth.id
  http_method = aws_api_gateway_method.auth_any.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  # Use the Lambda function ARN constructed from account/region/name so the
  # pipeline can create/update the function outside Terraform.
  uri = "arn:aws:apigateway:${var.region_default}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.region_default}:${data.aws_caller_identity.current.account_id}:function:${var.lambda_function_name}/invocations"
}

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

# ================================================================================
# DEPLOYMENT E STAGE
# ================================================================================

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id

  depends_on = [
    aws_api_gateway_method.auth_any,
    aws_api_gateway_method.proxy_any,
    aws_api_gateway_integration.auth_integration,
    aws_api_gateway_integration.proxy_integration,
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
