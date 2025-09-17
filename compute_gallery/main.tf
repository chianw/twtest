# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.1"
}


# This is required for resource modules
resource "azurerm_resource_group" "this" {
  location = "taiwannorth"
  name     = module.naming.resource_group.name_unique
}

module "compute_gallery" {
  source              = "Azure/avm-res-compute-gallery/azurerm"
  version             = "0.2.0"
  location            = azurerm_resource_group.this.location
  name                = module.naming.shared_image_gallery.name_unique
  resource_group_name = azurerm_resource_group.this.name
}