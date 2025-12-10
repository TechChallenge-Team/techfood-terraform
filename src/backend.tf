    terraform {
      backend "s3" {
        bucket         = "techfood-tf-bucket-techchallenge"
        key            = "terraform.tfstate"
        region         = "us-east-1"
        encrypt        = true
      }
    }