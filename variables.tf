# Common tags map to apply to all resources
variable "common_tags" {
  type = map(string)
  default = {
    environment = "dev"
    owner       = "victor"
    module      = "vmss"
  }
}

# Azure region to deploy resources in
variable "location" {
    description = "The Azure region to deploy resources in"
    type        = string
    default     = "westus2"
  
}

# Resource Group name
variable "resource_group_name" {
    description = "The name of the resource group"
    type        = string
    default     = "victor-rg"
}

# Virtual Network name
variable "vnet_name" {
    description = "The name of the Virtual Network"
    type        = string
    default     = "victor-vnet"
}

# Subnet name
variable "subnet" {
  description = "The name of the subnet"
  type = string
  default = "subnet"
}

# Name of the Virtual Machine Scale Set
variable "vmss_name" {
    description = "The name of the Virtual Machine Scale Set"
    type        = string
    default     = "my-vmss"
}

# Number of instances in the VMSS
variable "instance_count" {
    description = "The number of instances in the VMSS"
    type        = number
    default     = 3
}

# VM size with validation to prevent misconfiguration
variable "vm_size" {
    description = "The size of the VM instances"
    type        = string
    default     = "Standard_D2s_v4"
      validation {
    condition     = contains(["Standard_D2s_v4", "Standard_D4s_v3", "Standard_B2ms"], var.vm_size)
    error_message = "Invalid VM size. Choose from Standard_D2s_v4, Standard_D4s_v3, or Standard_B2ms."
  } # This prevents misconfiguration during onboarding.
}

# Admin username for the VM instances
variable "admin_username" {
    description = "The admin username for the VM instances"
    type        = string
    default     = "adminuser"
  
}

# Path to the SSH public key
variable "ssh_public_key_path" {
    description = "The path to the SSH public key"
    type        = string
    default     = "key.pub"
}

# Separating variables from logic is a fundamental Terraform practice: 

# it allows re-use across environments (dev/staging/prod) 
# and makes CI/CD pipelines much easier to parameterize.

# common_tags ensures consistent metadata (environment, owner, module) across all Azure resources, 
# which is crucial for accurate cost allocation, effective governance, and efficient cleanup.

# Storing the SSH public key path as a variable encourages use of key-based auth, 
# which Microsoft explicitly recommends for Linux VMs.