variable "projectName" {
  default = "techfood-terraform"
}

variable "region_default" {
  default = "us-east-1"
}

variable "cidr_vpc" {
  default = "10.0.0.0/16"
}

variable "tags" {
  default = {
    Name        = "techfood-terraform",
    School      = "FIAP",
    Environment = "Production",
    Year        = "2025"
  }
}

variable "instance_type" {
  default = "t3.medium"
}

variable "principal_user_arn" {
  default = "arn:aws:iam::767397785535:role/voclabs"
}

variable "eks_lab_role_arn" {
  default = "arn:aws:iam::767397785535:role/LabRole"
}
