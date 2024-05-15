resource "azurerm_container_group" "nginx_container" {
  name                = "${var.project_name}-container"
  location            = azurerm_resource_group.aci_rg.location
  resource_group_name = azurerm_resource_group.aci_rg.name
  os_type             = "Linux"
  restart_policy      = "OnFailure"
  ip_address_type     = "Public"
  dns_name_label      = "${var.project_name}-nginx"

  container {
    name   = "nginx"
    image  = "nginx:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}
