# Output the name of the Virtual Machine Scale Set
output "vmss_name" {
  description = "The name of the Virtual Machine Scale Set"
  value       = azurerm_orchestrated_virtual_machine_scale_set.vmss_main.name
}
