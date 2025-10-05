# ================================================================================
# API GATEWAY - HTTP API (v2)
# ================================================================================
resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "${var.projectName}-api-gateway"
  protocol_type = "HTTP"
  description   = "API Gateway service"

  tags = merge(var.tags, {
    Name = "${var.projectName}-api-gateway"
  })
}

# ================================================================================
# INTEGRAÇÃO COM LAMBDA (rotas /auth/*)
# ================================================================================
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  integration_type = "AWS_PROXY"
  integration_uri  = "arn:aws:lambda:${var.region_default}:${data.aws_caller_identity.current.account_id}:function:${var.lambda_function_name}"
  
  payload_format_version = "2.0"
}

# ================================================================================
# INTEGRAÇÃO COM EKS via VPC LINK (todas as outras rotas)
# ================================================================================
resource "aws_apigatewayv2_integration" "eks_integration" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  integration_uri    = aws_lb_listener.alb_listener.arn
  
  connection_type = "VPC_LINK"
  connection_id   = aws_apigatewayv2_vpc_link.vpc_link.id

  request_parameters = {
    "overwrite:path" = "$request.path"
  }
}

# ================================================================================
# ROTAS
# ================================================================================

# Rota para autenticação (Lambda)
resource "aws_apigatewayv2_route" "auth_route" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "ANY /auth/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Rota padrão para EKS (captura todas as outras rotas)
resource "aws_apigatewayv2_route" "default_route" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.eks_integration.id}"
}

# ================================================================================
# PERMISSÃO LAMBDA
# ================================================================================
# resource "aws_lambda_permission" "api_gateway_invoke_auth" {
#   statement_id  = "AllowAPIGatewayInvoke"
#   action        = "lambda:InvokeFunction"
#   function_name = var.lambda_function_name
#   principal     = "apigateway.amazonaws.com"
  
#   source_arn = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
# }

# ================================================================================
# STAGE
# ================================================================================
resource "aws_apigatewayv2_stage" "prod" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = "$default"
  auto_deploy = true

  tags = merge(var.tags, {
    Name = "${var.projectName}-api-gateway-stage"
  })
}
