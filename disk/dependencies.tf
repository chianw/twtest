resource "azurerm_disk_access" "this" {
  location            = azurerm_resource_group.this.location
  name                = replace(azurerm_resource_group.this.name, "rg", "da") # Naming module does not support disk access
  resource_group_name = azurerm_resource_group.this.name
  tags                = local.tags
}

data "azurerm_client_config" "current" {}

resource "azurerm_user_assigned_identity" "this" {
  location            = azurerm_resource_group.this.location
  name                = module.naming.user_assigned_identity.name_unique
  resource_group_name = azurerm_resource_group.this.name
  tags                = local.tags
}

module "key_vault" {
  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "0.5.3"

  location               = azurerm_resource_group.this.location
  name                   = module.naming.key_vault.name_unique
  resource_group_name    = azurerm_resource_group.this.name
  tenant_id              = data.azurerm_client_config.current.tenant_id
  enabled_for_deployment = true
  keys = {
    cmkfordisk = {
      key_opts = [
        "decrypt",
        "encrypt",
        "sign",
        "unwrapKey",
        "verify",
        "wrapKey"
      ]
      key_type     = "RSA"
      key_vault_id = module.key_vault.resource.id
      name         = "cmkfordisk"
      key_size     = 2048
      tags         = local.tags
    }
  }
  network_acls = {
    default_action = "Allow"
    bypass         = "AzureServices"
  }
  # Role recommended in this article: https://learn.microsoft.com/en-us/azure/virtual-machines/disk-encryption#full-control-of-your-keys
  role_assignments = {
    key_vault_administrator = {
      role_definition_id_or_name = "Key Vault Administrator"
      principal_id               = data.azurerm_client_config.current.object_id
    }
    key_vault_crypto_service_encryption_user = {
      role_definition_id_or_name = "Key Vault Crypto Service Encryption User"
      principal_id               = azurerm_user_assigned_identity.this.principal_id
    }
  }
  tags = local.tags
  wait_for_rbac_before_secret_operations = {
    create = "120s"
  }
}

resource "azurerm_disk_encryption_set" "this" {
  location            = azurerm_resource_group.this.location
  name                = module.naming.disk_encryption_set.name_unique
  resource_group_name = azurerm_resource_group.this.name
  key_vault_key_id    = module.key_vault.resource_keys["cmkfordisk"].id
  tags                = local.tags

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.this.id]
  }
}