# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = ">= 0.3.0"
}

# This is required for resource modules
# Hardcoding location due to quota constaints
resource "azurerm_resource_group" "this" {
  location = "taiwannorth"
  name     = module.naming.resource_group.name_unique
}

# This is the module call
module "test" {
  source  = "Azure/avm-res-web-serverfarm/azurerm"
  version = "0.7.0"

  location            = azurerm_resource_group.this.location
  name                = module.naming.app_service_plan.name_unique
  os_type             = "Windows"
  resource_group_name = azurerm_resource_group.this.name
  enable_telemetry    = false
}