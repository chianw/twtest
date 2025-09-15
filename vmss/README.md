### Got the following error deploying VMSS

```
│ Error: creating Orchestrated Virtual Machine Scale Set (Subscription: "d30aa1af-4fdf-427b-b19b-7fd032ffd95c"
│ Resource Group Name: "rg-fso9"
│ Virtual Machine Scale Set Name: "vmss-fso9"): polling after CreateOrUpdate: polling failed: the Azure API returned the following error:
│ 
│ Status: "BadRequest"
│ Code: ""
│ Message: "SKU 'Premium_LRS' is not available in availability zone '2'."
│ Activity Id: ""
│ 
│ ---
│ 
│ API Response:
│ 
│ ----[start]----
│ {
│   "startTime": "2025-09-15T06:55:29.792839+00:00",
│   "endTime": "2025-09-15T06:55:32.589694+00:00",
│   "status": "Failed",
│   "error": {
│     "code": "BadRequest",
│     "message": "SKU 'Premium_LRS' is not available in availability zone '2'.",
│     "target": "vmss-fso9_dad9f748"
│   },
│   "name": "49c6552a-6760-4ca4-8442-53b7a8f73a18"
│ }
│ -----[end]-----
│ 
│ 
│   with module.terraform_azurerm_avm_res_compute_virtualmachinescaleset.azurerm_orchestrated_virtual_machine_scale_set.virtual_machine_scale_set,
│   on .terraform/modules/terraform_azurerm_avm_res_compute_virtualmachinescaleset/main.tf line 1, in resource "azurerm_orchestrated_virtual_machine_scale_set" "virtual_machine_scale_set":
│    1: resource "azurerm_orchestrated_virtual_machine_scale_set" "virtual_machine_scale_set" {

```    