resource "mongodbatlas_encryption_at_rest" "test" {
  project_id = var.atlas_project_id

  azure_key_vault_config {
    enabled           = true
    azure_environment = "AZURE"

    tenant_id       = data.azurerm_client_config.current.tenant_id
    subscription_id = data.azurerm_client_config.current.subscription_id
    client_id       = azuread_application.example.client_id
    secret          = azuread_application_password.example.value

    resource_group_name = azurerm_resource_group.example.name
    key_vault_name      = azurerm_key_vault.example.name
    key_identifier      = azurerm_key_vault_key.example.id
  }
}

data "mongodbatlas_encryption_at_rest" "test" {
  project_id = mongodbatlas_encryption_at_rest.test.project_id
}

output "is_azure_encryption_at_rest_valid" {
  value = data.mongodbatlas_encryption_at_rest.test.azure_key_vault_config.valid
}
