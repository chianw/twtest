module "avm-res-storage-storageaccount" {
  source                    = "Azure/avm-res-storage-storageaccount/azurerm"
  version                   = "0.6.4"
  location                  = azurerm_resource_group.this_rg.location
  resource_group_name       = azurerm_resource_group.this_rg.name
  name                      = module.naming.storage_account.name_unique
  account_replication_type  = "LRS"
  shared_access_key_enabled = true
}