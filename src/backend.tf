    terraform {
      backend "s3" {
        bucket         = "techfood"
        key            = "terraform/terraform.tfstate"
        region         = "us-east-1"
        encrypt        = true
      }
    }