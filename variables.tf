variable "resource_group_name" {
  description = "The name of the resource group to create this virtual machine in."
  type        = string
}

variable "location" {
  description = "The location to create this virtual machine in."
  type        = string
}

variable "tags" {
  description = "A map of tags to be assign to this virtual machine and all its sub resources. If you only want to assign tags to the virtual machine itself use the vm_only_tags variable."
  type        = map(string)
  default     = {}
}

variable "vm_only_tags" {
  description = "A map of tags to be assign to the virtual machine resource only."
  type        = map(string)
  default     = {}
}

variable "vm_name" {
  description = "The name to be given to this virtual machine"
  type        = string
}

variable "vm_computer_name" {
  description = "The computer name (hostname) to be given to this virtual machine, default is the vm_name"
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

variable "disable_password_authentication" {
  description = "Should Password Authentication be disabled on this Virtual Machine"
  type        = bool
  default     = false
}

variable "admin_username" {
  description = "The username of the local administrator used for the Virtual Machine."
  type        = string
}

variable "admin_password" {
  description = "The Password of the local administrator used for the Virtual Machine"
  type        = string
}

variable "source_image" {
  description = "The Source image (OS) for this virtual machine"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = null
}

variable "os_disk" {
  description = "The OS disk for this VM"
  type = object({
    name                 = optional(string, null)
    size                 = optional(number, 256)
    caching              = optional(string, "ReadWrite")
    storage_account_type = optional(string, "Premium_LRS")
  })
}

variable "data_disks" {
  description = "A map of data disks to be used with this virtual machine"
  type = map(
    object({
      name                    = string
      storage_account_type    = optional(string, "Premium_LRS")
      create_option           = optional(string, "Empty")
      source_resource_id      = optional(string, null)
      storage_account_id      = optional(string, null)
      hyper_v_generation      = optional(string, null)
      size                    = optional(number, 1024)
      disk_attachment_lun     = optional(number, 0)
      disk_attachment_caching = optional(string, "none")
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

variable "extensions" {
  description = "Extensions to be install on this virtual machine"
  type = map(object({
    name                      = string
    publisher                 = string
    type                      = string
    type_handler_version      = string
    automatic_upgrade_enabled = optional(bool)
  }))
  default = {}
}

variable "backup" {
  description = "The backup policy and recovery service vault to be used to backup this virtual machine"
  type = object({
    policy_id = string
    recovery_service_vault = object({
      name           = string
      resource_group = string
    })
  })
  default = null
}

variable "custom_data" {
  description = "Cloud init configuration to be used during deplyment of this virtual machine"
  type        = any
  default     = null
}

variable "user_assigned_identity_ids" {
  description = "A list of user assigned identity ids to be assign to this virtual machine"
  type        = list(string)
  default     = []
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
