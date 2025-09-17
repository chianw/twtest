### Got the following error

```
╷
│ Error: retrieving queue properties for Storage Account (Subscription: "d30aa1af-4fdf-427b-b19b-7fd032ffd95c"
│ Resource Group Name: "rg-c0c7"
│ Storage Account Name: "stc0c7"): executing request: unexpected status 403 (403 Key based authentication is not permitted on this storage account.) with KeyBasedAuthenticationNotPermitted: Key based authentication is not permitted on this storage account.
│ RequestId:4b7700d9-4003-0064-35a7-237807000000
│ Time:2025-09-12T05:41:47.5924267Z
│ 
│   with module.avm-res-storage-storageaccount.azurerm_storage_account.this,
│   on .terraform/modules/avm-res-storage-storageaccount/main.tf line 1, in resource "azurerm_storage_account" "this":
│    1: resource "azurerm_storage_account" "this" {
│ 
╵
Releasing state lock. This may take a few moments...

```

Already enabled public access to allow GH runner access, but cannot enable storage account key access due to Azure policy restrictions