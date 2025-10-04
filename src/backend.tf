    terraform {
      backend "s3" {
        bucket         = "techfood-tf-bucket"
        key            = "terraform.tfstate"
        region         = "us-east-1"
        encrypt        = true
      }
    }