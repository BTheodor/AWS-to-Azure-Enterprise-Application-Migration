output "resource_group_name" {
  value       = azurerm_resource_group.net.name
  description = "The name of the resource group containing the networking resources."
}

output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "The ID of the Virtual Network."
}

output "vnet_name" {
  value       = azurerm_virtual_network.vnet.name
  description = "The name of the Virtual Network."
}

output "app_subnet_id" {
  value       = azurerm_subnet.app.id
  description = "The ID of the App Service integration subnet."
}

output "pe_subnet_id" {
  value       = azurerm_subnet.pe.id
  description = "The ID of the Private Endpoint subnet."
}

output "location" {
  value       = azurerm_resource_group.net.location
  description = "The location of the networking resources."
}