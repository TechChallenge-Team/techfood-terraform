    terraform {
      backend "s3" {
        bucket         = "techfood-bucket"
        key            = "terraform/terraform.tfstate"
        region         = "us-east-1"
        encrypt        = true
      }
    }