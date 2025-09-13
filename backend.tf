terraform {
  cloud {
    organization = "techfood-tf"

    workspaces {
      name = "production"
    }
  }
}
