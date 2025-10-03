module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.3.0"
}


resource "azurerm_resource_group" "example" {
  location = "taiwannorth"
  name     = module.naming.resource_group.name_unique
}

resource "azurerm_virtual_network" "example" {
  location            = azurerm_resource_group.example.location
  name                = module.naming.virtual_network.name_unique
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "example" {
  address_prefixes     = ["10.1.1.0/26"]
  name                 = module.naming.subnet.name_unique
  resource_group_name  = azurerm_virtual_network.example.resource_group_name
  virtual_network_name = azurerm_virtual_network.example.name
}

module "loadbalancer" {
  source  = "Azure/avm-res-network-loadbalancer/azurerm"
  version = "0.4.1"

  # Internal 
  # Standard SKU 
  # Regional 
  # Zone-redundant
  frontend_ip_configurations = {
    frontend_configuration_1 = {
      name                                   = "myFrontend"
      frontend_private_ip_subnet_resource_id = azurerm_subnet.example.id
      zones                                  = ["None"]
      # zones = ["1", "2", "3"] # Zone-redundant
      # zones = ["None"] # Non-zonal
    }
  }
  location            = azurerm_resource_group.example.location
  name                = "default-lb"
  resource_group_name = azurerm_resource_group.example.name
  enable_telemetry    = false
}