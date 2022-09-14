terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.21.1"
    }
  }

   used  to put the state file in the storage 
    backend "azurerm" {
    resource_group_name  = "example-resources"
    storage_account_name = "teststoragefordeployment"
    container_name       = "test"
    key                  = "avnet.tfstate"
  }


}

provider "azurerm" {
  # Configuration options
  features {}
}