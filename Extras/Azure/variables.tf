variable "location" {
  description = "Azure region where resources will be created"
  default     = "East US"
}

variable "project_name" {
  description = "Name of the project to create resources for"
  default     = "nginx-on-aci"
}
