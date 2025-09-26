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

# This is the module call
# Leaving location as `null` will cause the module to use the resource group location
# with a data source.
module "test" {
  source              = "Azure/avm-res-apimanagement-service/azurerm"
  version             = "0.0.5"
  location            = azurerm_resource_group.this.location
  name                = module.naming.api_management.name_unique
  publisher_email     = "chianwong@microsoft.com"
  resource_group_name = azurerm_resource_group.this.name
  enable_telemetry    = false
  publisher_name      = "Apim Example Publisher"
  sku_name            = "Premium_1"
  tags = {
    environment = "test"
    cost_center = "test"
  }
}