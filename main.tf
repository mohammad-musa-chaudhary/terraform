terraform {
  # required_providers {
  #   azurerm = {
  #     source = "hashicorp/azurerm"
  #     version = "2.13.0" #"3.21.1"
  #   }
  # }

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
  version = "=2.13.0" 
  skip_provider_registration = "true"
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


resource "azurerm_network_interface" "exampleNIC" {
  name                = "example-nic"
  location            = var.RegourceGropName 
  resource_group_name = var.RegourceGropName  

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "/subscriptions/9b5f80e7-022b-4269-942b-483d4a8e2df1/resourceGroups/example-resources/providers/Microsoft.Network/virtualNetworks/example-network/subnets/example-subnet"
    private_ip_address_allocation = "Dynamic"
  }
}