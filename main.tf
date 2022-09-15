terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.21.1"
    }
  }

   #used  to put the state file in the storage 
    backend "azurerm" {
    resource_group_name  = "example-resources"
    storage_account_name = "teststoragefordeployment"
    container_name       = "test"
    key                  = "project.tfstate"
  }

}

provider "azurerm" {
  # Configuration options
  features {}
}

# virtual network 
resource "azurerm_virtual_network" "example-network" {
  name                = "example-virtualnetwork"
  resource_group_name = var.RegourceGropName  
  location            = var.locationVariable 
  address_space       = ["10.0.0.0/16"]

    subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }
}


# 