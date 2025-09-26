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

module "event_hub" {
  source              = "Azure/avm-res-eventhub-namespace/azurerm"
  version             = "0.1.0"
  location            = azurerm_resource_group.this.location
  name                = module.naming.eventhub_namespace.name_unique
  resource_group_name = azurerm_resource_group.this.name
  enable_telemetry    = false
}