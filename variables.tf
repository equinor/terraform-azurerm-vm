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
  description = "The kind of VM to create. Value must be \"Linux\" or \"Windows\"."
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
  description = "The computer (host) name for this VM."
  type        = string
  default     = null
}

variable "admin_username" {
  description = "The admin username for this VM."
  type        = string
  nullable    = false
}

variable "admin_password" {
  description = "An admin password for this VM. If value is set to null, a random password is generated."
  type        = string
  nullable    = true
  default     = null
  sensitive   = true
}

variable "network_interfaces" {
  description = "A map of network interfaces to create for this VM."
  type = map(object({
    name = string
    ip_configurations = list(object({
      name      = string
      subnet_id = string
    }))
    network_security_group = optional(object({
      id = string
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
  description = "The type of caching that should be used for the OS disk. Value must be \"ReadWrite\", \"ReadOnly\" or \"None\"."
  type        = string
  default     = "ReadWrite"
  # By default, cache-capable OS disks will have read/write caching enabled.
  # Ref: https://learn.microsoft.com/en-us/azure/virtual-machines/disks-performance#virtual-machine-uncached-vs-cached-limits

  validation {
    condition     = contains(["ReadWrite", "ReadOnly", "None"], var.os_disk_caching)
    error_message = "OS disk caching must be \"ReadWrite\", \"ReadOnly\" or \"None\"."
  }
}

variable "os_disk_storage_account_type" {
  description = "The type of storage account which should be used for the OS disk. Value must be \"Standard_LRS\", \"StandardSSD_LRS\", \"Premium_LRS\", \"StandardSSD_ZRS\" or \"Premium_ZRS\"."
  type        = string
  default     = "StandardSSD_LRS"

  validation {
    condition     = contains(["Standard_LRS", "StandardSSD_LRS", "Premium_LRS", "StandardSSD_ZRS", "Premium_ZRS"], var.os_disk_storage_account_type)
    error_message = "OS disk Storage account type must be \"Standard_LRS\", \"StandardSSD_LRS\", \"Premium_LRS\", \"StandardSSD_ZRS\" or \"Premium_ZRS\"."
  }
}

variable "os_disk_size_gb" {
  description = "The size of this OS disk in gigabytes (GB)."
  type        = number
  default     = null
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

variable "storage_blob_endpoint" {
  description = "The blob endpoint of the Storage account to use for boot diagnostics."
  type        = string
  nullable    = false
}

variable "patch_mode" {
  description = "Specifies the guest patching mode for this VM. Value must be \"Manual\", \"ImageDefault\", \"AutomaticByOS\" or \"AutomaticByPlatform\"."
  type        = string
  default     = "AutomaticByPlatform"
  nullable    = false

  validation {
    condition     = contains(["Manual", "ImageDefault", "AutomaticByOS", "AutomaticByPlatform"], var.patch_mode)
    error_message = "Patch mode must be \"Manual\", \"ImageDefault\", \"AutomaticByOS\" or \"AutomaticByPlatform\"."
  }
}

variable "patch_assessment_mode" {
  description = "Specifies the patch assessment mode for this VM. Value must be \"ImageDefault\" or \"AutomaticByPlatform\"."
  type        = string
  default     = "AutomaticByPlatform"
  nullable    = false

  validation {
    condition     = contains(["ImageDefault", "AutomaticByPlatform"], var.patch_assessment_mode)
    error_message = "Patch assessment mode must be \"ImageDefault\" or \"AutomaticByPlatform\"."
  }
}

variable "custom_data" {
  description = "The custom data that should be used for this VM."
  type        = string
  default     = null
}

variable "system_assigned_identity_enabled" {
  description = "Should the system-assigned identity be enabled for this VM?"
  type        = bool
  default     = false
}

variable "identity_ids" {
  description = "A list of IDs of managed identities to be assigned to this VM."
  type        = list(string)
  default     = []
}

variable "data_disks" {
  description = "A map of data disks to be created and attached to this VM."
  type = map(object({
    name                   = string
    disk_size_gb           = number
    storage_account_type   = optional(string, "Standard_LRS")
    caching                = optional(string, "ReadWrite")
    create_option          = optional(string, "Empty")
    lun                    = optional(number)
    hyper_v_generation     = optional(string)
    disk_encryption_set_id = optional(string)
  }))
  default = {}
}

variable "extensions" {
  description = "A map of extensions to be installed for this VM."
  type = map(object({
    name                       = string
    publisher                  = string
    type                       = string
    type_handler_version       = string
    auto_upgrade_minor_version = optional(bool, true)
    automatic_upgrade_enabled  = optional(bool, false)
  }))
  default = {}
}

variable "tags" {
  description = "A map of tags to assign to all resources."
  type        = map(string)
  default     = {}
}

variable "vm_tags" {
  description = "A map of tags to assign to this VM."
  type        = map(string)
  default     = {}
}

variable "availability_set_id" {
  description = "The ID of an availability set in which this VM should be created."
  type        = string
  default     = null
}

variable "license_type" {
  description = "Specifies the type of existing on-prem license which should be used for this VM. Value must be \"None\", \"Windows_Client\", \"Windows_Server\", \"RHEL_BYOS\" or \"SLES_BYOS\"."
  type        = string
  default     = null
  nullable    = true

  validation {
    condition     = var.license_type == null ? true : contains(["None", "Windows_Client", "Windows_Server", "RHEL_BYOS", "SLES_BYOS"], var.license_type)
    error_message = "License type must be \"None\", \"Windows_Client\", \"Windows_Server\", \"RHEL_BYOS\" or \"SLES_BYOS\"."
  }
}

variable "os_disk_encryption_set_id" {
  description = "The ID of the Disk Encryption Set which should be used to encrypt this OS disk."
  type        = string
  default     = null
  nullable    = true
}

variable "encryption_at_host_enabled" {
  description = "Should all of the disks (including the temp disk) attached to this Virtual Machine be encrypted by enabling Encryption at Host?"
  type        = bool
  default     = false
}
