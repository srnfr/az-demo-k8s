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
}
resource "azurerm_resource_group" "rg" {
  name = "training-demo-srn"
  location = "westeurope-1"
}
