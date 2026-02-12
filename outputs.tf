output "apim_id" {
  description = "ID del API Management."
  value       = azurerm_api_management.apim.id
}

output "apim_name" {
  description = "Nombre del API Management."
  value       = azurerm_api_management.apim.name
}

output "apim_gateway_url" {
  description = "Gateway URL (endpoint principal)."
  value       = azurerm_api_management.apim.gateway_url
}

output "apim_public_ip_addresses" {
  description = "IPs públicas (si aplica)."
  value       = azurerm_api_management.apim.public_ip_addresses
}
