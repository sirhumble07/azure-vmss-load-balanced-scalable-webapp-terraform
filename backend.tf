terraform {
  backend "azurerm" {
    resource_group_name  = "vic-rg"
    storage_account_name = "vicstorageacct960"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}
