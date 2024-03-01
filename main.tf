# Local variables
locals {
  # Set to the same as the vm_name if not defined
  computer_name = try(var.computer_name, var.vm_name)

  # Merge the vm_only_tags and the tags variables
  vm_tags = merge(var.vm_only_tags, var.tags)

}


# Linux VM
resource "azurerm_linux_virtual_machine" "this" {
  count               = var.is_windows ? 0 : 1
  resource_group_name = var.resource_group_name
  location            = var.location

  name                            = var.vm_name
  computer_name                   = local.computer_name
  size                            = var.vm_size
  disable_password_authentication = var.disable_password_authentication
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  tags                            = local.vm_tags
  custom_data                     = var.custom_data

  bypass_platform_safety_checks_on_user_schedule_enabled = true

  network_interface_ids = [
    azurerm_network_interface.this.id
  ]

  source_image_reference {
    publisher = try(var.source_image.publisher, "canonical")
    offer     = try(var.source_image.offer, "0001-com-ubuntu-server-focal")
    sku       = try(var.source_image.sku, "20_04-lts-gen2")
    version   = try(var.source_image.version, "latest")
  }

  identity {
    type         = length(var.user_assigned_identity_ids) != 0 ? "SystemAssigned, UserAssigned" : "SystemAssigned"
    identity_ids = var.user_assigned_identity_ids
  }

  os_disk {
    name                 = coalesce(var.os_disk.name, "${var.host.name}-os-disk")
    disk_size_gb         = var.os_disk.size
    caching              = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type
  }

  boot_diagnostics {
    storage_account_uri = var.host.diag_storage_account_uri
  }

  availability_set_id = try(var.availability_set.id, null)

  lifecycle {
    ignore_changes = [
      # Needs to be ignored to prevent recreation when changes are made to the cloud init config
      custom_data
    ]
  }
}

# Windows VM
resource "azurerm_windows_virtual_machine" "this" {
  count               = var.host.is_windows ? 1 : 0
  resource_group_name = var.resource_group_name

  name           = var.host.name
  computer_name  = coalesce(var.host.computer_name, var.host.name)
  size           = var.host.size
  location       = var.location
  admin_username = "imadmin"
  admin_password = random_password.this.result
  tags           = merge({ "Omnia-OS-Type" = "WS2022" }, var.vm_only_tags, var.tags)
  license_type   = "Windows_Server"

  patch_assessment_mode = "AutomaticByPlatform"
  patch_mode            = "AutomaticByPlatform"

  bypass_platform_safety_checks_on_user_schedule_enabled = true
  provision_vm_agent                                     = true

  network_interface_ids = [
    azurerm_network_interface.this.id
  ]

  identity {
    type = "SystemAssigned"
  }

  source_image_reference {
    publisher = try(var.source_image.publisher, "MicrosoftWindowsServer")
    offer     = try(var.source_image.offer, "WindowsServer")
    sku       = try(var.source_image.sku, "2022-Datacenter-smalldisk")
    version   = try(var.source_image.version, "latest")
  }

  os_disk {
    name                 = coalesce(var.os_disk.name, "${var.host.name}-os-disk")
    disk_size_gb         = var.os_disk.size
    caching              = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type
  }

  boot_diagnostics {
    storage_account_uri = var.host.diag_storage_account_uri
  }
}
