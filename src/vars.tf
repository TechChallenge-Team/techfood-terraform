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
