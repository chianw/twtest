locals {
  prefix = "default"
  skus   = ["Basic", "Standard", "Premium"]
}


module "naming" {
  source  = "Azure/naming/azurerm"
  version = ">= 0.3.0"
}

resource "azurerm_resource_group" "example" {
  location = "taiwannorth"
  name     = "${module.naming.resource_group.name_unique}-${local.prefix}"
}

module "servicebus" {
  source   = "Azure/avm-res-servicebus-namespace/azurerm"
  version  = "0.4.0"
  for_each = toset(local.skus)

  location            = azurerm_resource_group.example.location
  name                = "${module.naming.servicebus_namespace.name_unique}-${each.value}-${local.prefix}"
  resource_group_name = azurerm_resource_group.example.name
  sku                 = each.value
}