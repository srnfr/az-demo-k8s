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

variable "username" {}

resource "azurerm_virtual_network" "example" {
  name                = "${var.prefix}-network"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
  address_space       = ["10.240.0.0/16"]
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  virtual_network_name = azurerm_virtual_network.example.name
  resource_group_name  = data.azurerm_resource_group.example.name
  address_prefixes     = ["10.240.1.0/24"]
}

resource "azurerm_kubernetes_cluster" "example" {
    name                = var.cluster_name
    location            = data.azurerm_resource_group.example.location
    resource_group_name = data.azurerm_resource_group.example.name
    dns_prefix          = var.prefix

    linux_profile {
      admin_username = "var.username"
      ssh_key {
        key_data = data.azurerm_ssh_public_key.example.public_key
      }
    }
  
    default_node_pool {
        name            = "defaultpool"
        node_count      = var.node_count
        vm_size         = var.node_size
        ##vnet_subnet_id = azurerm_subnet.internal.id
        enable_node_public_ip = true
        pod_subnet_id = azurerm_subnet.internal.id
        
    }

   identity {
    type = "SystemAssigned"
   }

    network_profile {
        load_balancer_sku = "Standard"
        ##network_plugin = "azure"
        network_plugin = "kubenet"
        network_policy = "calico"
        pod_cidr = "10.244.0.0/23"
        service_cidr = "100.245.0.0/24"
    }
}
