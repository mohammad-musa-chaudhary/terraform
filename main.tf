terraform {
  # required_providers {
  #   azurerm = {
  #     source = "hashicorp/azurerm"
  #     version = "2.13.0" #"3.21.1"
  #   }
  # }

   #used  to put the state file in the storage 
    backend "azurerm" {
    resource_group_name  = "testrg2"
    storage_account_name = "teststoragefordeployment"
    container_name       = "qnbshare"
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
  
#  /*                                     Create Virtual machine                                */

# # public ip 
resource "azurerm_public_ip" "testPublicIP" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = var.RegourceGropName
  location            = var.locationVariable 
  allocation_method   = "Static"
}

# # network interface 
   #   assign public ip created above in to NIC not to the VM 
resource "azurerm_network_interface" "exampleNIC" {
  name                = "example-nic"
  location            = var.locationVariable
  resource_group_name = var.RegourceGropName  

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "/subscriptions/9b5f80e7-022b-4269-942b-483d4a8e2df1/resourceGroups/example-resources/providers/Microsoft.Network/virtualNetworks/example-virtualnetwork/subnets/subnet1"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.testPublicIP.id
  }
}

# # virtual machine
resource "azurerm_linux_virtual_machine" "exampleVM" {
  name                = "example-machine"
  resource_group_name = var.RegourceGropName  
  location            = var.locationVariable 
  size                = "Standard_F2"
  disable_password_authentication = false
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.exampleNIC.id,
  ]

#   admin_ssh_key {
#     username   = "adminuser"
#     public_key = file("~/.ssh/id_rsa.pub")
#   }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}


# #  /*                                     Create App service                                */

 
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



# /*                                     Create Kubernetes cluster                                */


# resource "azurerm_kubernetes_cluster" "example" {
#   name                = "example-aks1"
#   location            = var.locationVariable
#   resource_group_name = var.RegourceGropName
#   dns_prefix          = "exampleaks1"

#   default_node_pool {
#     name       = "default"
#     node_count = 1
#     vm_size    = "Standard_D2_v2"
#   }

#   identity {
#     type = "SystemAssigned"
#   }

#   tags = {
#     Environment = "Production"
#   }
# }

# output "client_certificate" {
#   value     = azurerm_kubernetes_cluster.example.kube_config.0.client_certificate
#   sensitive = true
# }

# output "kube_config" {
#   value = azurerm_kubernetes_cluster.example.kube_config_raw

#   sensitive = true
# }


/*                                 Create Application Gateway                                  */

# resource "azurerm_virtual_network" "example" {
#   name                = "example-network"
#   resource_group_name = var.RegourceGropName
#   location            = var.locationVariable
#   address_space       = ["10.254.0.0/16"]
# }

# resource "azurerm_subnet" "frontend" {
#   name                 = "frontend"
#   resource_group_name  = var.RegourceGropName
#   virtual_network_name = azurerm_virtual_network.example.name
#   address_prefixes     = ["10.254.0.0/24"]
# }

# resource "azurerm_subnet" "backend" {
#   name                 = "backend"
#   resource_group_name  = var.RegourceGropName
#   virtual_network_name = azurerm_virtual_network.example.name
#   address_prefixes     = ["10.254.2.0/24"]
# }

# resource "azurerm_public_ip" "example" {
#   name                = "example-pip"
#   resource_group_name = var.RegourceGropName
#   location            = var.locationVariable
#   allocation_method   = "Dynamic"
# }

# #&nbsp;since these variables are re-used - a locals block makes this more maintainable
# locals {
#   backend_address_pool_name      = "${azurerm_virtual_network.example.name}-beap"
#   frontend_port_name             = "${azurerm_virtual_network.example.name}-feport"
#   frontend_ip_configuration_name = "${azurerm_virtual_network.example.name}-feip"
#   http_setting_name              = "${azurerm_virtual_network.example.name}-be-htst"
#   listener_name                  = "${azurerm_virtual_network.example.name}-httplstn"
#   request_routing_rule_name      = "${azurerm_virtual_network.example.name}-rqrt"
#   redirect_configuration_name    = "${azurerm_virtual_network.example.name}-rdrcfg"
# }

# resource "azurerm_application_gateway" "network" {
#   name                = "example-appgateway"
#   resource_group_name = var.RegourceGropName
#   location            = var.locationVariable

#   sku {
#     name     = "Standard_Small"
#     tier     = "Standard"
#     capacity = 2
#   }

#   gateway_ip_configuration {
#     name      = "my-gateway-ip-configuration"
#     subnet_id = azurerm_subnet.frontend.id
#   }

#   frontend_port {
#     name = local.frontend_port_name
#     port = 80
#   }

#   frontend_ip_configuration {
#     name                 = local.frontend_ip_configuration_name
#     public_ip_address_id = azurerm_public_ip.example.id
#   }

#   backend_address_pool {
#     name = local.backend_address_pool_name
#   }

#   backend_http_settings {
#     name                  = local.http_setting_name
#     cookie_based_affinity = "Disabled"
#     path                  = "/path1/"
#     port                  = 80
#     protocol              = "Http"
#     request_timeout       = 60
#   }

#   http_listener {
#     name                           = local.listener_name
#     frontend_ip_configuration_name = local.frontend_ip_configuration_name
#     frontend_port_name             = local.frontend_port_name
#     protocol                       = "Http"
#   }

#   request_routing_rule {
#     name                       = local.request_routing_rule_name
#     rule_type                  = "Basic"
#     http_listener_name         = local.listener_name
#     backend_address_pool_name  = local.backend_address_pool_name
#     backend_http_settings_name = local.http_setting_name
#   }
# }


# /*                                          Creat Firewall                                */

# resource "azurerm_virtual_network" "example" {
#   name                = "testvnet"
#   address_space       = ["10.0.0.0/16"]
#   location            = var.locationVariable
#   resource_group_name = var.RegourceGropName
# }

# resource "azurerm_subnet" "example" {
#   name                 = "AzureFirewallSubnet"
#   resource_group_name  = var.RegourceGropName
#   virtual_network_name = azurerm_virtual_network.example.name
#   address_prefixes     = ["10.0.1.0/24"]
# }

# resource "azurerm_public_ip" "example" {
#   name                = "testpip"
#   location            = var.locationVariable
#   resource_group_name = var.RegourceGropName
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }

# resource "azurerm_firewall" "example" {
#   name                = "testfirewall"
#   location            = var.locationVariable
#   resource_group_name = var.RegourceGropName
#   #sku_name            = "AZFW_VNet"
#   #sku_tier            = "Standard"

#   ip_configuration {
#     name                 = "configuration"
#     subnet_id            = azurerm_subnet.example.id
#     public_ip_address_id = azurerm_public_ip.example.id
#   }
# }



/*                                    Bastion Service                                    */

# resource "azurerm_subnet" "AuzreBastionSubnet" {
#   name                 = "AuzreBastionSubnet"
#   resource_group_name  = var.RegourceGropName
#   virtual_network_name = azurerm_virtual_network.example.name
#   address_prefixes     = ["10.0.2.0/26"]
# }



# resource "azurerm_public_ip" "BastionPiblicIP" {
#   name                = "BastionPiblicIP"
#   location            = var.locationVariable
#   resource_group_name = var.RegourceGropName
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }

# resource "azurerm_bastion_host" "bastionService" {
#   name                = "bastionService"
#   location            = var.locationVariable
#   resource_group_name = var.RegourceGropName

#   ip_configuration {
#     name                 = "configuration"
#     subnet_id            = azurerm_subnet.AuzreBastionSubnet.id
#     public_ip_address_id = azurerm_public_ip.BastionPiblicIP.id
#   }
# }