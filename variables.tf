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
  default     = "Standard_B1s" # TODO: set appropriate default value
  nullable    = false
}

variable "admin_username" {
  description = "The admin username for this VM."
  type        = string
  nullable    = false
}

variable "os_disk_name" {
  description = "The name of this OS disk."
  type        = string
}

variable "os_disk_caching" {
  description = "" # TODO: write description
  type        = string
  default     = "None" # TODO: set appropriate default value
}

variable "os_disk_storage_account_type" {
  description = "" # TODO: write description
  type        = string
  default     = "Standard_LRS" # TODO: set appropriate default value
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

  # TODO: validate that at least one IP configuration is configured for each network interface
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
