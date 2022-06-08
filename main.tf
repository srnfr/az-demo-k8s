##variable "location" {
##  type        = string
##}

variable "resource_group_name" {}

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

resource "azurerm_virtual_network" "supernet" {
  name                = "${var.prefix}-network"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
  address_space       = ["10.240.0.0/16"]
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  virtual_network_name = azurerm_virtual_network.supernet.name
  resource_group_name  = data.azurerm_resource_group.example.name
  address_prefixes     = ["10.240.1.0/24"]
}

resource "azurerm_kubernetes_cluster" "example" {
    name                = var.cluster_name
    location            = data.azurerm_resource_group.example.location
    resource_group_name = data.azurerm_resource_group.example.name
    dns_prefix          = var.prefix

    linux_profile {
      admin_username = var.username
      ssh_key {
        key_data = data.azurerm_ssh_public_key.example.public_key
      }
    }
  
    default_node_pool {
        name            = "defaultpool"
        enable_auto_scaling = true
        node_count      = var.node_count
        vm_size         = var.node_size
        enable_node_public_ip = true
        min_count = 2
        max_count = 4
        ##vnet_subnet_id = azurerm_subnet.internal.id
        ##pod_subnet_id = azurerm_subnet.internal.id
        
    }

   identity {
    type = "SystemAssigned"
   }

    network_profile {
        load_balancer_sku = "Standard"
        ##-----
        network_plugin = "azure"
        network_policy = "calico"
        ##-----
        ##network_plugin = "kubenet"
        ## see https://docs.microsoft.com/en-us/azure/aks/configure-azure-cni
        ##pod_cidr = "10.244.0.0/22"
        ##service_cidr = "10.245.0.0/24"
        ##dns_service_ip = "10.245.0.250"
        ##docker_bridge_cidr = "172.17.2.1/24"
    }
} 

