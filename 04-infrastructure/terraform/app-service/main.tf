locals {
  prefix = "${var.project_name}-${var.environment}"
}

# 1. Resource Group for App Service
resource "azurerm_resource_group" "app" {
  name     = "rg-${local.prefix}-app-001"
  location = var.location
  tags     = var.tags
}

# 2. App Service Plan (Linux) for Frontend
resource "azurerm_service_plan" "frontend" {
  name                = "asp-${local.prefix}-fe-001"
  resource_group_name = azurerm_resource_group.app.name
  location            = azurerm_resource_group.app.location
  os_type             = "Linux"
  sku_name            = "P1v3"
  tags                = var.tags
}

# 3. App Service Plan (Windows) for Backend
resource "azurerm_service_plan" "backend" {
  name                = "asp-${local.prefix}-be-001"
  resource_group_name = azurerm_resource_group.app.name
  location            = azurerm_resource_group.app.location
  os_type             = "Windows"
  sku_name            = "P1v3"
  tags                = var.tags
}

# 4. Frontend Web App (React)
resource "azurerm_linux_web_app" "frontend" {
  name                = "app-${local.prefix}-fe-001"
  resource_group_name = azurerm_resource_group.app.name
  location            = azurerm_resource_group.app.location
  service_plan_id     = azurerm_service_plan.frontend.id

  site_config {
    application_stack {
      node_version = "18-lts"
    }
  }

  virtual_network_subnet_id = var.app_subnet_id
  tags = var.tags
}

# 5. Backend Web App (.NET Core)
resource "azurerm_windows_web_app" "backend" {
  name                = "app-${local.prefix}-be-001"
  resource_group_name = azurerm_resource_group.app.name
  location            = azurerm_resource_group.app.location
  service_plan_id     = azurerm_service_plan.backend.id

  site_config {
    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v6.0"
    }
  }

  app_settings = {
    "DbConnectionString"   = var.db_connection_string
    "StorageAccountName"   = var.storage_account_name
    "Environment"          = var.environment
  }

  identity {
    type = "SystemAssigned"
  }

  virtual_network_subnet_id = var.app_subnet_id
  tags = var.tags
}