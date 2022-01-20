terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

variable "client_id" {}
variable "client_secret" {}

provider "azurerm" {
  features {}
  
  subscription_id = var.sub_id
  client_id       =  var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id

  
}
resource "azurerm_resource_group" "rg" {
  name = "training-demo-srn"
  location = "westeurope-1"
}
