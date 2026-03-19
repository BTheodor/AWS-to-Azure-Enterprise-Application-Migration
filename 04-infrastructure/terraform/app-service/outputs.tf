output "frontend_url" {
  value = azurerm_linux_web_app.frontend.default_hostname
}

output "backend_url" {
  value = azurerm_windows_web_app.backend.default_hostname
}

output "backend_managed_identity_principal_id" {
  value = azurerm_windows_web_app.backend.identity[0].principal_id
}