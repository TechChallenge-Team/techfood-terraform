    terraform {
      backend "s3" {
        bucket         = "techfood-state-bucket"
        key            = "techfood/terraform.tfstate"
        region         = "us-east-1"
        encrypt        = true
      }
    }