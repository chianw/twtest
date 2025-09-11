resource "azurerm_resource_group" "kv_rg" {
  location = "taiwannorth"
  name     = "kv-taiwantest-rg"
}

data "azurerm_client_config" "current" {}

module "avm-res-keyvault-vault" {
  source              = "Azure/avm-res-keyvault-vault/azurerm"
  version             = "0.10.1"
  resource_group_name = azurerm_resource_group.kv_rg.name
  location            = azurerm_resource_group.kv_rg.location
  name                = "avmtestkv01"
  tenant_id           = data.azurerm_client_config.current.tenant_id
}