locals {
  tags = {
    scenario = "default"
  }
}



# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.2"
}

# This is required for resource modules
resource "azurerm_resource_group" "this" {
  location = "taiwannorth"
  name     = module.naming.resource_group.name_unique
}


# This is the module call
module "basic" {
  source  = "Azure/avm-res-cache-redis/azurerm"
  version = "0.4.0"

  location            = azurerm_resource_group.this.location
  name                = module.naming.redis_cache.name_unique
  resource_group_name = azurerm_resource_group.this.name
  enable_telemetry    = false
  sku_name            = "Basic"
  tags                = local.tags
  zones               = null
}