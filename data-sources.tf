
data "azurerm_resource_group" "example" {
  ## DATA block because already exists and managed externally
  name     = "${var.resource_group_name}"
}

data "azurerm_ssh_public_key" "example" {
  name                = "srn"
  resource_group_name = "training-demo-srn"
}
