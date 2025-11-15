
# network security group for the subnet with a rule to allow http, https and ssh traffic
resource "azurerm_network_security_group" "myNSG" {
  name                = "myNSG"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags =  local.common_tags

  dynamic "security_rule" {
     for_each = local.allowed_ports
    content {
      name                       = "allow-${security_rule.key}"
      priority                   = 110 + index(keys(local.allowed_ports), security_rule.key) * 10
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
# Allow traffic from the Azure Load Balancer probe
    security_rule {
    name                       = "Allow-LB-Probe"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "AzureLoadBalancer"
    source_port_range          = "*"
    destination_port_range     = "80"
    destination_address_prefix = "*"
  }
}

# Associate the network security group with the subnet
resource "azurerm_subnet_network_security_group_association" "myNSG" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.myNSG.id
}
