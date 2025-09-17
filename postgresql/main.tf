# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.4"
}

# This is required for resource modules
resource "azurerm_resource_group" "this" {
  location = "taiwannorth"
  name     = module.naming.resource_group.name_unique
}

resource "random_password" "myadminpassword" {
  length           = 16
  override_special = "_%@"
  special          = true
}

# This is the module call
# Do not specify location here due to the randomization above.
# Leaving location as `null` will cause the module to use the resource group location
# with a data source.
module "test" {
  source  = "Azure/avm-res-dbforpostgresql-flexibleserver/azurerm"
  version = "0.1.4"

  location               = azurerm_resource_group.this.location
  name                   = module.naming.postgresql_server.name_unique
  resource_group_name    = azurerm_resource_group.this.name
  administrator_login    = "psqladmin"
  administrator_password = random_password.myadminpassword.result
  enable_telemetry       = false
  high_availability = {
    mode = "SameZone"
    # standby_availability_zone = 2
  }
  server_version = 16
  sku_name       = "GP_Standard_D2s_v3"
  tags           = null
  zone           = 1
}