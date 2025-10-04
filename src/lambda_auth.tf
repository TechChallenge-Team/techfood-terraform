// Lambda + API Gateway for TechFood Authentication

// Caller identity (used to create more unique bucket name)
data "aws_caller_identity" "current" {}

// S3 bucket to store lambda package
resource "aws_s3_bucket" "lambda_artifacts" {
  bucket        = lower("${var.projectName}-lambda-artifacts-${data.aws_caller_identity.current.account_id}-${var.region_default}")
  force_destroy = true

  tags = merge(var.tags, { Service = "lambda-artifacts" })
}

// Note: artifact upload and function code deployment will be done by the
// GitHub Actions pipeline in the `techfood-authentication` repository.
// Here we create only the S3 bucket where the pipeline can upload the package.

// NOTE: Not creating IAM role or policies due to AWS Academy restrictions.
// The CI/CD pipeline MUST either reuse an existing IAM role or the
// pipeline/operator must create the role with the appropriate policies.
// Terraform here will only create infra that doesn't require elevated IAM
// privileges (bucket + API Gateway resources). The pipeline should call
// `aws lambda add-permission` after creating the Lambda, if needed.

// The Lambda function itself (code) will be created/updated by the GitHub
// Actions pipeline. We only set the canonical function name here so the
// pipeline and other systems know which name to use.

variable "lambda_function_name" {
  type        = string
  description = "Name of the Lambda function that the CI/CD pipeline will deploy."
  default     = "TechFoodAuthenticationLambda"
}

variable "lambda_handler" {
  type        = string
  default     = "TechFood.Lambda.Authentication::TechFood.Lambda.Authentication.Function::FunctionHandler"
  description = "The Lambda handler. Kept for reference; deployment pipeline uses its own settings."
}

variable "lambda_runtime" {
  type    = string
  default = "dotnet8"
}

variable "lambda_memory_size" {
  type    = number
  default = 512
}

variable "lambda_timeout" {
  type    = number
  default = 30
}


// Integrate Authentication Lambda into the existing API Gateway (api-gateway.tf)
// Creates /v1/authentication/signin under the existing rest API
resource "aws_api_gateway_resource" "auth_v1" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_rest_api.api-gateway.root_resource_id
  path_part   = "v1"
}

resource "aws_api_gateway_resource" "auth_authentication" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_resource.auth_v1.id
  path_part   = "authentication"
}

resource "aws_api_gateway_resource" "auth_signin" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_resource.auth_authentication.id
  path_part   = "signin"
}

resource "aws_api_gateway_method" "signin_post" {
  rest_api_id   = aws_api_gateway_rest_api.api-gateway.id
  resource_id   = aws_api_gateway_resource.auth_signin.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "signin_integration" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  resource_id = aws_api_gateway_resource.auth_signin.id
  http_method = aws_api_gateway_method.signin_post.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  # Use the Lambda function ARN constructed from account/region/name so the
  # pipeline can create/update the function outside Terraform.
  uri = "arn:aws:apigateway:${var.region_default}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.region_default}:${data.aws_caller_identity.current.account_id}:function:${var.lambda_function_name}/invocations"
}

// Note: Permission for API Gateway to invoke the Lambda should be added
// by the pipeline that creates the Lambda (e.g. using
// aws lambda add-permission --function-name <name> --statement-id ...).

// Outputs
output "auth_lambda_function_name" {
  value = var.lambda_function_name
  description = "Lambda function name that the pipeline should deploy to"
}

output "auth_lambda_function_arn" {
  value = "arn:aws:lambda:${var.region_default}:${data.aws_caller_identity.current.account_id}:function:${var.lambda_function_name}"
  description = "Full ARN for the Lambda function (useful in CI/CD)"
}

output "auth_api_invoke_url" {
  value = "https://${aws_api_gateway_rest_api.api-gateway.id}.execute-api.${var.region_default}.amazonaws.com/prod/v1/authentication/signin"
  description = "Public invoke URL for the Authentication endpoint (stage prod)"
}

output "auth_bucket_name" {
  value       = aws_s3_bucket.lambda_artifacts.id
  description = "S3 bucket where the CI pipeline should upload the Lambda package"
}

// IAM role is not created in this Terraform due to restricted IAM permissions
// in AWS Academy. Create role manually or via separate process and configure
// the pipeline to use it.
