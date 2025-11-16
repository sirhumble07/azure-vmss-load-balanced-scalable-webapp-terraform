# Generate a random pet name for VMSS hostname
resource "random_pet" "vmss_hostname" {
  length    = 2
  separator = "-"
}

# Create an Azure Orchestrated Virtual Machine Scale Set (VMSS)
resource "azurerm_orchestrated_virtual_machine_scale_set" "vmss_main" {
  name                        = local.vmss_final_name
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  sku_name                    = var.vm_size
  instances                   = 3
  platform_fault_domain_count = 1     # For zonal deployments
  zones                       = ["1"] # Deploy in zone 1
  tags                        = var.common_tags

  os_profile {
    custom_data = base64encode(file("user-data.sh"))
    linux_configuration {
      disable_password_authentication = true
      admin_username                  = var.admin_username
      admin_ssh_key {
        username   = var.admin_username
        public_key = file(var.ssh_public_key_path)
      }
    }
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-LTS-gen2"
    version   = "latest"
  }
  os_disk {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name                          = "nic"
    primary                       = true
    enable_accelerated_networking = false

    ip_configuration {
      name                                   = "ipconfig"
      primary                                = true
      subnet_id                              = azurerm_subnet.subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bepool.id]
    }
  }

  boot_diagnostics {
    storage_account_uri = ""
  }

  # Ignore changes to the instances property, so that the VMSS is not recreated when the number of instances is changed
  lifecycle {
    ignore_changes = [instances]
  }
}
