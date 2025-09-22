module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.3.0"

  suffix = ["test"]
}

# Create a Resource Group in the randomly selected region
resource "azurerm_resource_group" "example" {
  location = "taiwannorth"
  name     = module.naming.resource_group.name_unique
}

# Call the Backup Vault Module
module "backup_vault" {
  source              = "Azure/avm-res-dataprotection-backupvault/azurerm"
  version             = "0.3.0"
  datastore_type      = "VaultStore"
  location            = azurerm_resource_group.example.location
  name                = module.naming.recovery_services_vault.name_unique
  redundancy          = "LocallyRedundant"
  resource_group_name = azurerm_resource_group.example.name
  diagnostic_settings = {}
  enable_telemetry    = false # Enable telemetry (optional)
}