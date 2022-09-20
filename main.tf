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

# # virtual network 
# resource "azurerm_virtual_network" "example-network" {
#   name                = "example-virtualnetwork"
#   resource_group_name = var.RegourceGropName  
#   location            = var.locationVariable 
#   address_space       = ["10.0.0.0/16"]

#     subnet {
#     name           = "subnet1"
#     address_prefix = "10.0.1.0/24"
#   }
# }
  
#  /*                                     Create Virtual machine                                */

# # public ip 
# resource "azurerm_public_ip" "testPublicIP" {
#   name                = "acceptanceTestPublicIp1"
#   resource_group_name = var.RegourceGropName
#   location            = var.locationVariable 
#   allocation_method   = "Static"
# }

# # network interface 
#    #   assign public ip created above in to NIC not to the VM 
# resource "azurerm_network_interface" "exampleNIC" {
#   name                = "example-nic"
#   location            = var.locationVariable
#   resource_group_name = var.RegourceGropName  

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = "/subscriptions/9b5f80e7-022b-4269-942b-483d4a8e2df1/resourceGroups/example-resources/providers/Microsoft.Network/virtualNetworks/example-virtualnetwork/subnets/subnet1"
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id = azurerm_public_ip.testPublicIP.id
#   }
# }

# # virtual machine
# resource "azurerm_linux_virtual_machine" "exampleVM" {
#   name                = "example-machine"
#   resource_group_name = var.RegourceGropName  
#   location            = var.locationVariable 
#   size                = "Standard_F2"
#   disable_password_authentication = false
#   admin_username      = "adminuser"
#   admin_password      = "P@$$w0rd1234!"
#   network_interface_ids = [
#     azurerm_network_interface.exampleNIC.id,
#   ]

# #   admin_ssh_key {
# #     username   = "adminuser"
# #     public_key = file("~/.ssh/id_rsa.pub")
# #   }

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "16.04-LTS"
#     version   = "latest"
#   }
# }


#  /*                                     Create App service                                */

 
# resource "azurerm_app_service_plan" "exampleexampleAppServicePlan" {
#   name                = "example-appserviceplan"
#   location            = var.locationVariable 
#   resource_group_name = var.RegourceGropName 

#   sku {
#     tier = "Basic"
#     size = "S1"
#   }
# }


# resource "azurerm_app_service" "exampleAppService" {
#   name                = "example-app-service-example-resources-fortest"
#   location            = var.locationVariable
#   resource_group_name = var.RegourceGropName
#   app_service_plan_id = azurerm_app_service_plan.exampleexampleAppServicePlan.id

#   site_config {
#     dotnet_framework_version = "v4.0"
#     scm_type                 = "LocalGit"
#   }

#   app_settings = {
#     "SOME_KEY" = "some-value"
#   }

#   connection_string {
#     name  = "Database"
#     type  = "SQLServer"
#     value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
#   }
# }



/*                                     Create Kubernetes cluster                                */


resource "azurerm_kubernetes_cluster" "example" {
  name                = "example-aks1"
  location            = var.locationVariable
  resource_group_name = var.RegourceGropName
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.example.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.example.kube_config_raw

  sensitive = true
}