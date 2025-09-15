module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.4"
}


resource "azurerm_resource_group" "this_rg" {
  location = "taiwannorth"
  name     = module.naming.resource_group.name_unique
}

module "avm-res-compute-virtualmachinescaleset" {
  source                      = "Azure/avm-res-compute-virtualmachinescaleset/azurerm"
  version                     = "0.8.0"
  location                    = "taiwannorth"
  name                        = "twvmss1"
  resource_group_name         = azurerm_resource_group.this_rg.name
  extension_protected_setting = {}
  user_data_base64            = null

  os_profile = {
    linux_configuration = {
      disable_password_authentication = true
      admin_username                  = "azureuser"
    }
  }

}