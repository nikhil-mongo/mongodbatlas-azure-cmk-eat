Here’s the README.md in markdown format:

# Azure Key Vault Integration with MongoDB Atlas Using Terraform

This repository contains Terraform configurations to set up an Azure Key Vault and integrate it with MongoDB Atlas for encryption at rest. It also demonstrates assigning proper roles and permissions to an Azure Active Directory (Azure AD) application.

## Project Structure

| File           | Description                                                                                         |
| -------------- | --------------------------------------------------------------------------------------------------- |
| `versions.tf`  | Specifies the required providers and their versions.                                                |
| `provider.tf`  | Configures providers for AzureRM, AzureAD, and MongoDB Atlas.                                       |
| `variables.tf` | Defines the input variables for project configuration, such as MongoDB Atlas project credentials.   |
| `azure-kv.tf`  | Creates Azure Key Vault, its keys, and manages access policies and roles for Azure AD applications. |
| `atlas-cmk.tf` | Configures MongoDB Atlas with encryption at rest using Azure Key Vault.                             |

---

## Prerequisites

1. **Terraform CLI**: Ensure Terraform is installed. ([Install Terraform](https://developer.hashicorp.com/terraform/tutorials))
2. **Azure Account**: You must have an active Azure subscription and required permissions to manage Azure resources.
3. **MongoDB Atlas**: Access to a MongoDB Atlas project with admin credentials.
4. **Azure CLI**: Install Azure CLI and log in:
   ```bash
   az login
   ```

Setup Instructions

1. Clone the Repository

git clone <repository-url>
cd <repository-folder>

2. Initialize Terraform

Run the following command to initialize the Terraform working directory:

terraform init

3. Configure Variables

Edit the variables.tf file or create a terraform.tfvars file with the following variables:
• atlas_project_id: MongoDB Atlas project ID.
• mongodbatlas_public_key: MongoDB Atlas public API key.
• mongodbatlas_private_key: MongoDB Atlas private API key.

Example terraform.tfvars:

atlas_project_id = "your-atlas-project-id"
mongodbatlas_public_key = "your-public-key"
mongodbatlas_private_key = "your-private-key"

4. Deploy the Infrastructure

Run the following commands to review and apply the configuration:

terraform plan
terraform apply

Resources Created 1. Azure Key Vault:
• Key Vault with specified access policies and keys.
• RSA Key used for encryption at rest in MongoDB Atlas. 2. Azure AD Application:
• An Azure AD application and service principal are created for accessing the Key Vault.
• The service principal is assigned the Key Vault Reader role. 3. MongoDB Atlas Encryption at Rest:
• Integrates MongoDB Atlas with Azure Key Vault for encryption at rest.

Outputs

The following outputs are provided after successful deployment:

Output Description
application_client_id The Client ID of the Azure AD application.
application_client_secret The Client Secret of the Azure AD application.
tenant_id The Azure AD tenant ID.
azurerm_key_vault_key_identifier The unique identifier of the Key Vault key.
is_azure_encryption_at_rest_valid Indicates whether encryption at rest is properly configured in MongoDB Atlas.

Cleanup

To destroy the created resources, run:

terraform destroy

Notes
• The Key Vault is configured with soft delete enabled for 7 days, but purge protection is disabled.
• Ensure the service principal’s permissions are managed securely to prevent unauthorized access.
• Verify the role assignments and access policies to maintain the principle of least privilege.

License

This project is licensed under the MIT License.

You can save this markdown text as `README.md` in your repository. Let me know if you need further adjustments or enhancements!
