# I added a modified_on tag with the current date, which automatically timestamps deployments.
locals {
  common_tags = {
    modified_on = formatdate("YYYY-MM-DD", timestamp())
  }

  # Define VM size map based on environment
  vm_size_map = {
    dev     = "Standard_D2s_v4"
    staging = "Standard_D2s_v4"
    prod    = "Standard_D4s_v3"
  }

  # Select VM size based on environment
  vm_size = local.vm_size_map["dev"]

  # allowed_ports is a map for HTTP, HTTPS, and SSH that I reuse in my NSG.
  allowed_ports = {
    http  = "80"
    https = "443"
    ssh   = "22"
  }
}

# Generate unique names for resources using random_pet so resource names stay unique and human-readable.
locals {
  vmss_final_name = "${var.vmss_name}-${random_pet.vmss_hostname.id}"
}

# Generate unique names for Load Balancer resources
locals {
  lb_name        = "LB-${random_pet.lb_hostname.id}"
  natgw_name     = "NATGW-${random_pet.lb_hostname.id}"
  public_ip_name = "LB-PublicIP"
}