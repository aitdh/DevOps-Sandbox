resource "azurerm_virtual_network" "vnet" {
  name                = "vnet_${replace(var.ARM_RG_NAME,"-","_")}"
  location            = var.devops_sb_resource_group_location
  resource_group_name = var.ARM_RG_NAME
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "var.environment"
  }
}

resource "azurerm_subnet" "snet" {
  name                 = "snet_devops_sandbox"
  resource_group_name  = var.ARM_RG_NAME
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "webapp_snet" {
  name                 = "webapp_snet_devops_sandbox"
  resource_group_name  = var.ARM_RG_NAME
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]

  delegation {
    name = "webapp_snet_delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
    }
  }
}
