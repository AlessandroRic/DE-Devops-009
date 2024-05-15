output "public_ip_address" {
  value       = azurerm_container_group.nginx_container.ip_address
  description = "The public IP address of the NGINX container instance."
}
