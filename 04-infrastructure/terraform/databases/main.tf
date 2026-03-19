locals {
  prefix = "${var.project_name}-${var.environment}"
}

# 1. Resource Group for Database
resource "azurerm_resource_group" "db" {
  name     = "rg-${local.prefix}-db-001"
  location = var.location
  tags     = var.tags
}

# 2. Azure SQL Server
resource "azurerm_mssql_server" "sql" {
  name                         = "sql-${local.prefix}-001"
  resource_group_name          = azurerm_resource_group.db.name
  location                     = azurerm_resource_group.db.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
  public_network_access_enabled = false

  tags = var.tags
}

# 3. Azure SQL Database (Serverless)
resource "azurerm_mssql_database" "db" {
  name                 = "db-${local.prefix}-001"
  server_id            = azurerm_mssql_server.sql.id
  collation            = "SQL_Latin1_General_CP1_CI_AS"
  sku_name             = "GP_S_Gen5_1" # Serverless General Purpose
  max_size_gb          = 100
  min_capacity         = 0.5
  auto_pause_delay_in_minutes = 60

  tags = var.tags
}

# 4. Private DNS Zone for SQL
resource "azurerm_private_dns_zone" "sql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.db.name
}

# 5. Link Private DNS Zone to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "sql" {
  name                  = "link-sql-dns-to-vnet"
  resource_group_name   = azurerm_resource_group.db.name
  private_dns_zone_name = azurerm_private_dns_zone.sql.name
  virtual_network_id    = var.vnet_id
}

# 6. Private Endpoint for SQL Server
resource "azurerm_private_endpoint" "sql" {
  name                = "pe-${local.prefix}-sql-001"
  location            = azurerm_resource_group.db.location
  resource_group_name = azurerm_resource_group.db.name
  subnet_id           = var.pe_subnet_id

  private_service_connection {
    name                           = "psc-${local.prefix}-sql-001"
    private_connection_resource_id = azurerm_mssql_server.sql.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }

  private_dns_zone_group {
    name                 = "dns-zone-group-sql"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql.id]
  }
}