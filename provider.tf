provider "azurerm" {
  features {}
  subscription_id = "e930b152-7bfc-4b65-b9db-3f24a109db82"
}

provider "azuread" {}
provider "mongodbatlas" {
public_key  = var.mongodbatlas_public_key
private_key = var.mongodbatlas_private_key
}
