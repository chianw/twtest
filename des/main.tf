data "azurerm_client_config" "current" {}

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.3.0"
}

# This is required for resource modules
resource "azurerm_resource_group" "this" {
  location = "taiwannorth"
  name     = module.naming.resource_group.name_unique
}


module "avm_res_keyvault_vault" {
  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "=0.10.0"

  location                    = azurerm_resource_group.this_rg.location
  name                        = "${module.naming.key_vault.name_unique}-linux-ssh"
  resource_group_name         = azurerm_resource_group.this_rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption = true
  keys = {
    des_key = {
      name     = "des-disk-key"
      key_type = "RSA"
      key_size = 2048

      key_opts = [
        "decrypt",
        "encrypt",
        "sign",
        "unwrapKey",
        "verify",
        "wrapKey",
      ]
    }
  }
  network_acls = {
    default_action = "Allow"
    bypass         = "AzureServices"
  }
  role_assignments = {
    deployment_user_secrets = { #give the deployment user access to secrets
      role_definition_id_or_name = "Key Vault Secrets Officer"
      principal_id               = data.azurerm_client_config.current.object_id
    }
    deployment_user_keys = { #give the deployment user access to keys
      role_definition_id_or_name = "Key Vault Crypto Officer"
      principal_id               = data.azurerm_client_config.current.object_id
    }
    user_managed_identity_keys = { #give the user assigned managed identity for the disk encryption set access to keys
      role_definition_id_or_name = "Key Vault Crypto Officer"
      principal_id               = azurerm_user_assigned_identity.example_identity.principal_id
      principal_type             = "ServicePrincipal"
    }
  }

  wait_for_rbac_before_key_operations = {
    create = "60s"
  }
  wait_for_rbac_before_secret_operations = {
    create = "60s"
  }
}

module "des" {
  source  = "Azure/avm-res-compute-diskencryptionset/azurerm"
  version = "0.1.0"

  key_vault_key_id      = module.avm_res_keyvault_vault.keys_resource_ids.des_key.id
  key_vault_resource_id = module.avm_res_keyvault_vault.resource_id
  location              = azurerm_resource_group.this.location
  name                  = module.naming.disk_encryption_set.name_unique
  resource_group_name   = azurerm_resource_group.this.name
  enable_telemetry      = false
  managed_identities = {
    system_assigned = true
  }
}