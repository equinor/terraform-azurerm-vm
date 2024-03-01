variable "resource_group_name" {
  description = "The name of the resource group to create this virtual machine in."
  type        = string
}

variable "location" {
  description = "The location to create this virtual machine in."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to this virtual machine."
  type        = map(string)
  default     = {}
}

variable "vm_name" {
  description = "The name to be given to this virtual machine"
  type        = string
}

variable "vm_computer_name" {
  description = "The computer name to be given to this virtual machine, default is the vm_name"
  type        = string
  default     = null
}

variable "vm_size" {
  description = "What size should the virtual machine be, default is Standard_D2s_v4"
  type        = string
  default     = "Standard_D2s_v4"
}

variable "is_windows" {
  description = "Should this virtual machine run Windows, default is linux"
  type        = bool
  default     = false
}

variable "os_disk" {
  description = "The OS disk for this VM"
  type = object({
    name                 = optional(string, "")
    size                 = optional(number, 256)
    caching              = optional(string, "ReadWrite")
    storage_account_type = optional(string, "Premium_LRS")
  })
}

variable "data_disks" {
  description = "data disks for this virtual machine"
  type = map(
    object({
      name                 = optional(string, "")
      storage_account_type = optional(string, "Premium_LRS")
      create_option        = optional(string, "Empty")
      source_resource_id   = optional(string, "")
      storage_account_id   = optional(string, null)
      hyper_v_generation   = optional(string, null)
      size                 = optional(number, 1024)
    })
  )
}

variable "network_interfaces" {
  description = "All network interfaces for this virtual machine"
  type = map(object({
    ip_configuration = object({
      subnet_id             = string
      nsg_group_id          = optional(string, null)
      ip_address_allocation = optional(string, "Dynamic")
      ip_config_name        = optional(string, null)
      dns_servers           = optional(list(string), null)
    })
  }))
}

variable "boot_diagnostics_storage_account_uri" {
  description = "The Primary/Secondary Endpoint for the Azure Storage Account which should be used to store Boot Diagnostics, including Console Output and Screenshots from the Hypervisor."
  type        = string
  default     = null
}

variable "availability_set_id" {
  description = "Specifies the ID of the Availability Set in which this Virtual Machine should exist"
  type = object({
    id = string
  })
  default = null
}
