terraform {
  cloud {
    organization = "soat-tf"

    workspaces {
      name = "production"
    }
  }
}
