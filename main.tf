##variable "location" {
##  type        = string
##}

variable "resource_group_name" {
  type        = string
}

variable "prefix" {
  type        = string
}

variable "cluster_name" {
  type        = string
}

variable "node_count" {
  type        = string
}

variable "node_size" {
  type        = string
}

#####


data "azurerm_resource_group" "example" {
  ## DATA block because already exists and managed externally
  name     = "${var.resource_group_name}"
  ##location = "${var.location}"
}

resource "azurerm_virtual_network" "example" {
  name                = "${var.prefix}-network"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  virtual_network_name = azurerm_virtual_network.example.name
  resource_group_name  = azurerm_resource_group.example.name
  address_prefixes     = ["10.1.0.0/22"]
}

resource "azurerm_kubernetes_cluster" "example" {
    name                = var.cluster_name
    location            = azurerm_resource_group.example.location
    resource_group_name = azurerm_resource_group.example.name
    dns_prefix          = var.prefix


    default_node_pool {
        name            = "defaultpool"
        node_count      = var.node_count
        vm_size         = var.node_size
        vnet_subnet_id = azurerm_subnet.internal.id
    }

   identity {
    type = "SystemAssigned"
   }

    network_profile {
        load_balancer_sku = "Standard"
        network_plugin = "azure"
        network_policy = "calico"
    }
}
