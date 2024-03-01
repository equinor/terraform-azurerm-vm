variable "vm_name" {
  description = "The name of this VM."
  type        = string
  nullable    = false
}

variable "resource_group_name" {
  description = "The name of the resource group to create the resources in."
  type        = string
  nullable    = false
}

variable "location" {
  description = "The location to create the resources in."
  type        = string
  nullable    = false
}

variable "kind" {
  description = "The kind of VM to create."
  type        = string
  default     = "Linux"
  nullable    = false

  validation {
    condition     = contains(["Linux", "Windows"], var.kind)
    error_message = "Kind must be \"Linux\" or \"Windows\"."
  }
}

variable "size" {
  description = "The SKU which should be used for this VM."
  type        = string
  default     = "Standard_B1s"
  nullable    = false
}

variable "computer_name" {
  description = "value"
  type        = string
  default     = null
}

variable "admin_username" {
  description = "The admin username for this VM."
  type        = string
  nullable    = false
}

variable "network_interfaces" {
  description = "A map of network interfaces to create for this VM."
  type = map(object({
    name = string
    ip_configurations = list(object({
      name      = string
      subnet_id = string
    }))
  }))
  nullable = false

  validation {
    condition     = length(var.network_interfaces) > 0
    error_message = "At least one network interface must be created for this VM."
  }

  validation {
    condition     = alltrue([for nic in var.network_interfaces : length(nic.ip_configurations) > 0])
    error_message = "At least one IP configuration must be configured for each network interface."
  }
}

variable "os_disk_name" {
  description = "The name of this OS disk."
  type        = string
}

variable "os_disk_caching" {
  description = "The type of caching that should be used for the OS disk."
  type        = string
  default     = "ReadWrite"
  # By default, cache-capable OS disks will have read/write caching enabled.
  # Ref: https://learn.microsoft.com/en-us/azure/virtual-machines/disks-performance#virtual-machine-uncached-vs-cached-limits
}

variable "os_disk_storage_account_type" {
  description = "The type of storage account which should be used for the OS disk."
  type        = string
  default     = "StandardSSD_LRS"
}

variable "source_image_publisher" {
  description = "The publisher of the image used to create this VM."
  type        = string
  default     = null
}

variable "source_image_offer" {
  description = "The offer of the image used to create this VM."
  type        = string
  default     = null
}

variable "source_image_sku" {
  description = "The SKU of the image used to create this VM."
  type        = string
  default     = null
}

variable "source_image_version" {
  description = "The version of the image used to create this VM."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
