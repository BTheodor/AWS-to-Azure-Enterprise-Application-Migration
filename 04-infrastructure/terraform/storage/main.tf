locals {
  prefix = "${var.project_name}-${var.environment}"
}

# 1. Resource Group for Storage
resource "azurerm_resource_group" "st" {
  name     = "rg-${local.prefix}-storage-001"
  location = var.location
  tags     = var.tags
}

# 2. Storage Account
resource "azurerm_storage_account" "st" {
  name                     = "st${replace(local.prefix, "-", "")}001"
  resource_group_name      = azurerm_resource_group.st.name
  location                 = azurerm_resource_group.st.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  public_network_access_enabled = false

  tags = var.tags
}

# 3. Storage Container
resource "azurerm_storage_container" "docs" {
  name                  = "documents"
  storage_account_name  = azurerm_storage_account.st.name
  container_access_type = "private"
}

# 4. Private DNS Zone for Blob Storage
resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.st.name
}

# 5. Link Private DNS Zone to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "blob" {
  name                  = "link-blob-dns-to-vnet"
  resource_group_name   = azurerm_resource_group.st.name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = var.vnet_id
}

# 6. Private Endpoint for Blob Storage
resource "azurerm_private_endpoint" "blob" {
  name                = "pe-${local.prefix}-blob-001"
  location            = azurerm_resource_group.st.location
  resource_group_name = azurerm_resource_group.st.name
  subnet_id           = var.pe_subnet_id

  private_service_connection {
    name                           = "psc-${local.prefix}-blob-001"
    private_connection_resource_id = azurerm_storage_account.st.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "dns-zone-group-blob"
    private_dns_zone_ids = [azurerm_private_dns_zone.blob.id]
  }
}