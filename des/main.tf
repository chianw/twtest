data "azurerm_client_config" "current" {}

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.3.0"
}

# This is required for resource modules
resource "azurerm_resource_group" "this" {
  location = "taiwannorth"
  name     = module.naming.resource_group.name_unique
}


module "keyvault" {
  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "0.9.1"

  location                    = azurerm_resource_group.this.location
  name                        = module.naming.key_vault.name_unique
  resource_group_name         = azurerm_resource_group.this.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption = true
  network_acls = {
    bypass                     = "AzureServices"
    default_action             = "Allow"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }
  purge_protection_enabled = false
  sku_name                 = "standard"
}

resource "azurerm_key_vault_key" "example" {
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
  key_type     = "RSA"
  key_vault_id = module.keyvault.resource_id
  name         = "des-example-key"
  key_size     = 2048
}

module "des" {
  source  = "Azure/avm-res-compute-diskencryptionset/azurerm"
  version = "0.1.0"

  key_vault_key_id      = azurerm_key_vault_key.example.id
  key_vault_resource_id = module.keyvault.resource_id
  location              = azurerm_resource_group.this.location
  name                  = module.naming.disk_encryption_set.name_unique
  resource_group_name   = azurerm_resource_group.this.name
  enable_telemetry      = false
  managed_identities = {
    system_assigned = true
  }
}