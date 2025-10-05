    terraform {
      backend "s3" {
        bucket         = "techfood-terraform-bucket"
        key            = "terraform.tfstate"
        region         = "us-east-1"
        encrypt        = true
      }
    }