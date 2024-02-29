locals {
  is_windows = var.kind == "Windows"
  vm         = local.is_windows ? azurerm_windows_virtual_machine.this[0] : azurerm_linux_virtual_machine.this[0]

  network_interface_ids = [for v in azurerm_network_interface.this : v.id]
}

resource "random_password" "this" {
  length      = 123
  lower       = true
  upper       = true
  numeric     = true
  special     = true
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
}

resource "azurerm_network_interface" "this" {
  for_each = var.network_interfaces

  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = var.location

  dynamic "ip_configuration" {
    for_each = each.value.ip_configurations

    content {
      name                          = ip_configuration.value.name
      subnet_id                     = ip_configuration.value.subnet_id
      private_ip_address_allocation = "Dynamic"
    }
  }
}

resource "azurerm_linux_virtual_machine" "this" {
  count = local.is_windows ? 0 : 1

  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size

  admin_username                  = var.admin_username
  admin_password                  = random_password.this.result
  disable_password_authentication = false

  network_interface_ids = local.network_interface_ids

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

  # TODO: get values from variables
  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-minimal-focal"
    sku       = "minimal-20_04-lts-gen2"
    version   = "latest"
  }

  tags = var.tags
}

resource "azurerm_windows_virtual_machine" "this" {
  count = local.is_windows ? 1 : 0

  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size

  computer_name  = substr(var.vm_name, 0, 15) # TODO: find better solution here
  admin_username = var.admin_username
  admin_password = random_password.this.result

  network_interface_ids = local.network_interface_ids

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

  # TODO: get values from variables
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  tags = var.tags
}

# TODO: add diagnostic setting?
