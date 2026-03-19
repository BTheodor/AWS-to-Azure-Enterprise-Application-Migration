locals {
  prefix = "${var.project_name}-${var.environment}"
}

# 1. Resource Group for Networking
resource "azurerm_resource_group" "net" {
  name     = "rg-${local.prefix}-networking-001"
  location = var.location
  tags     = var.tags
}

# 2. Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${local.prefix}-001"
  location            = azurerm_resource_group.net.location
  resource_group_name = azurerm_resource_group.net.name
  address_space       = [var.vnet_cidr]
  tags                = var.tags
}

# 3. App Service Subnet (with Delegation for Regional VNet Integration)
resource "azurerm_subnet" "app" {
  name                 = "snet-app-integration-001"
  resource_group_name  = azurerm_resource_group.net.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.app_subnet_cidr]

  delegation {
    name = "app-service-delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# 4. Private Endpoint Subnet
resource "azurerm_subnet" "pe" {
  name                 = "snet-private-endpoints-001"
  resource_group_name  = azurerm_resource_group.net.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.private_endpoint_subnet_cidr]

  # Necessary to allow Private Endpoints to connect to this subnet
  private_endpoint_network_policies_enabled = true
}

# 5. Network Security Groups (NSGs)

# NSG for App Service Subnet
resource "azurerm_network_security_group" "nsg_app" {
  name                = "nsg-${local.prefix}-app-001"
  location            = azurerm_resource_group.net.location
  resource_group_name = azurerm_resource_group.net.name
  tags                = var.tags

  security_rule {
    name                       = "AllowHTTPSInboundFromFrontDoor"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "AzureFrontDoor.Backend"
    destination_address_prefix = "*"
  }
}

# NSG for Private Endpoint Subnet
resource "azurerm_network_security_group" "nsg_pe" {
  name                = "nsg-${local.prefix}-pe-001"
  location            = azurerm_resource_group.net.location
  resource_group_name = azurerm_resource_group.net.name
  tags                = var.tags

  # Restrict all inbound traffic except from the App Subnet
  security_rule {
    name                       = "AllowInboundFromAppSubnet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.app_subnet_cidr
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# 6. Subnet-NSG Associations
resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.nsg_app.id
}

resource "azurerm_subnet_network_security_group_association" "pe" {
  subnet_id                 = azurerm_subnet.pe.id
  network_security_group_id = azurerm_network_security_group.nsg_pe.id
}