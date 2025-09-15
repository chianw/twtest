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
module "disk" {
  source  = "Azure/avm-res-compute-disk/azurerm"
  version = "v0.3.2"

  create_option = "Empty"

  location               = azurerm_resource_group.this.location
  name                   = module.naming.managed_disk.name_unique
  resource_group_name    = azurerm_resource_group.this.name
  storage_account_type   = "Premium_LRS"
  zone                   = 1
  disk_encryption_set_id = azurerm_disk_encryption_set.this.id
  disk_size_gb           = 1024
  enable_telemetry       = false
  network_access_policy  = "AllowAll"
}