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
  enable_telemetry            = false

  os_profile = {
    linux_configuration = {
      disable_password_authentication = true
      admin_username                  = "azureuser"
      patch_mode                      = "ImageDefault"
    }
  }
  automatic_instance_repair = {
    enabled = false
  }

  sku_name = "Standard_B2ms"
  source_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-LTS-gen2" # Auto guest patching is enabled on this sku.  https://learn.microsoft.com/en-us/azure/virtual-machines/automatic-vm-guest-patching
    version   = "latest"
  }

}