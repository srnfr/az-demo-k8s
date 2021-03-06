
data "azurerm_resource_group" "example" {
  ## DATA block because already exists and managed externally
  name     = "${var.resource_group_name}"
}

data "azurerm_ssh_public_key" "example" {
  name                = "${var.ssh_key_name}"
  resource_group_name = "${var.resource_group_name}"
}
#data "azurerm_resources" "example" {
#  resource_group_name = "${var.rg_nsg}"
#  type = "Microsoft.Network/networkSecurityGroups"
#}

#output name_nsg {
#    value = data.azurerm_resources.example.resources.0.name
#}
