terraform {
  backend "azurerm" {
    resource_group_name  = "vic-rg"
    storage_account_name = "vicstorageacct18616"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}
