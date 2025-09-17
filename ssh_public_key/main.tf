# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = ">= 0.3.0"
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# This is required for resource modules
resource "azurerm_resource_group" "this" {
  location = "taiwannorth"
  name     = module.naming.resource_group.name_unique
}

# This is the module call
# Do not specify location here due to the randomization above.
# Leaving location as `null` will cause the module to use the resource group location
# with a data source.
module "test" {
  source              = "Azure/avm-res-compute-sshpublickey/azurerm"
  version             = "0.1.0"
  name                = "sshkeyexample"
  public_key          = tls_private_key.example.public_key_openssh
  resource_group_name = azurerm_resource_group.this.name
  enable_telemetry    = false

}