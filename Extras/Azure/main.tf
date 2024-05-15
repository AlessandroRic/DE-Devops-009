resource "azurerm_resource_group" "aci_rg" {
  name     = "${var.project_name}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "aci_vnet" {
  name                = "${var.project_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.aci_rg.name
}

resource "azurerm_subnet" "aci_subnet" {
  name                 = "${var.project_name}-subnet"
  resource_group_name  = azurerm_resource_group.aci_rg.name
  virtual_network_name = azurerm_virtual_network.aci_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "aci_nsg" {
  name                = "${var.project_name}-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.aci_rg.name
}

resource "azurerm_subnet_network_security_group_association" "aci_subnet_nsg_assoc" {
  subnet_id                 = azurerm_subnet.aci_subnet.id
  network_security_group_id = azurerm_network_security_group.aci_nsg.id
}
