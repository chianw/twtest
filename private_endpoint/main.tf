# This allows us to randomize the region for the resource group.
resource "random_integer" "region_index" {
  max = length(module.regions.regions) - 1
  min = 0
}
## End of section to provide a random Azure region for the resource group

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = ">= 0.3.0"
}

# This is required for resource modules
resource "azurerm_resource_group" "this" {
  location = "taiwannorth"
  name     = module.naming.resource_group.name_unique
}

resource "azurerm_key_vault" "this" {
  location                    = azurerm_resource_group.this.location
  name                        = module.naming.key_vault.name_unique
  resource_group_name         = azurerm_resource_group.this.name
  sku_name                    = "standard"
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption = true
  purge_protection_enabled    = false
  soft_delete_retention_days  = 7

  access_policy {
    key_permissions = [
      "Get",
    ]
    object_id = data.azurerm_client_config.current.object_id
    secret_permissions = [
      "Get",
    ]
    storage_permissions = [
      "Get",
    ]
    tenant_id = data.azurerm_client_config.current.tenant_id
  }
}

resource "azurerm_virtual_network" "this" {
  location            = azurerm_resource_group.this.location
  name                = module.naming.virtual_network.name_unique
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "this" {
  address_prefixes     = ["10.0.1.0/24"]
  name                 = module.naming.subnet.name_unique
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
}


# This is the module call
# Do not specify location here due to the randomization above.
# Leaving location as `null` will cause the module to use the resource group location
# with a data source.
module "test" {
  source  = "Azure/avm-res-network-privateendpoint/azurerm"
  version = "0.2.0"

  location                       = azurerm_resource_group.this.location
  name                           = module.naming.private_endpoint.name_unique
  network_interface_name         = module.naming.network_interface.name_unique
  private_connection_resource_id = azurerm_key_vault.this.id
  resource_group_name            = azurerm_resource_group.this.name
  subnet_resource_id             = azurerm_subnet.this.id
  enable_telemetry               = false
  subresource_names              = ["vault"]
}