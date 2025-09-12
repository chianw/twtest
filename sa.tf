# assign service principal Storage Blob Data Contributor role scoped to the resource group

resource "azurerm_role_assignment" "example" {
  scope                = azurerm_resource_group.this_rg.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}


module "avm-res-storage-storageaccount" {
  source                    = "Azure/avm-res-storage-storageaccount/azurerm"
  version                   = "0.6.4"
  location                  = azurerm_resource_group.this_rg.location
  resource_group_name       = azurerm_resource_group.this_rg.name
  name                      = module.naming.storage_account.name_unique
  account_replication_type  = "LRS"
  shared_access_key_enabled = true
  depends_on = [ azurerm_role_assignment.example ]
}