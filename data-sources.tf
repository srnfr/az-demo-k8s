
data "azurerm_resource_group" "example" {
  ## DATA block because already exists and managed externally
  name     = "${var.resource_group_name}"
}
