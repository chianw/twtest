# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.0"
}

resource "azurerm_resource_group" "this" {
  location = "taiwannorth"
  name     = module.naming.resource_group.name_unique
}


module "recovery_services_vault" {
  source                                         = "Azure/avm-res-recoveryservices-vault/azurerm"
  version                                        = "0.3.2"
  location                                       = azurerm_resource_group.this.location
  name                                           = "twtestrsv1212"
  resource_group_name                            = azurerm_resource_group.this.name
  sku                                            = "RS0"
  alerts_for_all_job_failures_enabled            = true
  alerts_for_critical_operation_failures_enabled = true
  classic_vmware_replication_enabled             = false
  cross_region_restore_enabled                   = false
  public_network_access_enabled                  = true
  storage_mode_type                              = "LocallyRedundant"
  tags = {
    env   = "Prod"
    owner = "ABREG0"
    dept  = "IT"
  }
}