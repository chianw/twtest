

data "azurerm_subscription" "current" {}

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
module "network_manager" {
  source  = "Azure/avm-res-network-networkmanager/azurerm"
  version = "0.2.1"

  location = azurerm_resource_group.this.location
  name     = "network-manager"
  network_manager_scope = {
    subscription_ids = ["/subscriptions/${data.azurerm_subscription.current.subscription_id}"]
  }
  network_manager_scope_accesses = ["Connectivity", "SecurityAdmin"]
  resource_group_name            = azurerm_resource_group.this.name
  # source             = "Azure/avm-<res/ptn>-<name>/azurerm"
  # ...
  enable_telemetry = false
}  