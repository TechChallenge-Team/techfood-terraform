variable "projectName" {
  default = "techfood"
}

variable "principal_user_arn" {
  description = "The ARN of the principal user"
}

variable "eks_lab_role_arn" {
  description = "The ARN of the EKS lab role"
}

variable "region_default" {
  default = "us-east-1"
}

variable "cidr_vpc" {
  default = "10.0.0.0/16"
}

variable "instance_type" {
  default = "t3.medium"
}

variable "tags" {
  default = {
    Name        = "techfood",
    School      = "FIAP",
    Environment = "Production",
    Year        = "2025"
  }
}

# Variables for the Lambda function deployed by the CI/CD pipeline
variable "lambda_function_name" {
  type        = string
  description = "Name of the Lambda function that the CI/CD pipeline will deploy."
}

variable "lambda_handler" {
  type        = string
  default     = "TechFood.Authentication"
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
