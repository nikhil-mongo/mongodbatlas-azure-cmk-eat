# Get Azure tenant and current client information
data "azurerm_client_config" "current" {}

# Resource Group
resource "azurerm_resource_group" "example" {
  name     = "atlas-resource-group"
  location = "East US"
}

# Key Vault
resource "azurerm_key_vault" "example" {
  name                       = "atlas-key-vault-nik"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  # Key Vault access policy for current user
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "Create", "Delete", "List", "Update", "GetRotationPolicy"
    ]
    secret_permissions = [
      "Get", "List", "Set", "Delete",
    ]
  }
}

# Key Vault Key
resource "azurerm_key_vault_key" "example" {
  name         = "atlas-key-atlas"
  key_vault_id = azurerm_key_vault.example.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

# Azure AD Application
resource "azuread_application" "example" {
  display_name     = "atlas-application"
  sign_in_audience = "AzureADMyOrg"
}

# Azure AD Service Principal
resource "azuread_service_principal" "example" {
  client_id = azuread_application.example.client_id
}

# Key Vault Access Policy for Service Principal
resource "azurerm_key_vault_access_policy" "app_policy" {
  key_vault_id = azurerm_key_vault.example.id
  tenant_id    = azuread_service_principal.example.application_tenant_id
  object_id    = azuread_service_principal.example.object_id
  key_permissions = [
    "Get", "List", "WrapKey", "UnwrapKey", "Encrypt", "Decrypt"
  ]
  secret_permissions = [
    "Get", "List",
  ]
}

# Azure AD Application Password
resource "azuread_application_password" "example" {
  application_id = azuread_application.example.id
  display_name   = "atlas-client-secret"
  end_date       = "2099-12-31T23:59:59Z"
}

# Assign Key Vault Reader role to the application
resource "azurerm_role_assignment" "key_vault_reader" {
  scope                = azurerm_key_vault.example.id
  role_definition_name = "Key Vault Reader"
  principal_id         = azuread_service_principal.example.object_id
}

# Outputs
output "application_client_id" {
  value = azuread_application.example.client_id
}

output "application_client_secret" {
  value     = azuread_application_password.example.value
  sensitive = true
}
output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

output "azurerm_key_vault_key_identifier" {
  value = azurerm_key_vault_key.example.id
}
