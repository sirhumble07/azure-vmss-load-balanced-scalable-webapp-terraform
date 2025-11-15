# Create an Azure Resource Group, which will contain all other resources
resource "azurerm_resource_group" "rg" {
    name     = var.resource_group_name
    location = var.location
  
}