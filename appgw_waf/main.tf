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

# This is the module call
# Do not specify location here due to the randomization above.
# Leaving location as `null` will cause the module to use the resource group location
# with a data source.
module "test" {
  source  = "Azure/avm-res-network-applicationgatewaywebapplicationfirewallpolicy/azurerm"
  version = "0.2.0"

  # source             = "Azure/avm-<res/ptn>-<name>/azurerm"
  # ...
  location = azurerm_resource_group.this.location
  managed_rules = {
    managed_rule_set = {
      owasp = {
        version = "3.2"
        type    = "OWASP"
      }
    }
  }
  name                = module.naming.firewall_policy.name_unique
  resource_group_name = azurerm_resource_group.this.name
  enable_telemetry    = false
  policy_settings = {
    enabled                                   = false
    file_upload_limit_in_mb                   = 100
    js_challenge_cookie_expiration_in_minutes = 30
    max_request_body_size_in_kb               = 128
    mode                                      = "Detection"
    request_body_check                        = true
    request_body_inspect_limit_in_kb          = 128
  }
}