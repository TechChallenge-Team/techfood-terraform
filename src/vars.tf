variable "projectName" {
  default = "techfood"
}

variable "principal_user_arn" {
  default = "arn:aws:iam::767397785535:role/voclabs"
}

variable "eks_lab_role_arn" {
  default = "arn:aws:iam::767397785535:role/LabRole"
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
