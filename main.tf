locals {
  is_windows = var.kind == "Windows"
  vm         = local.is_windows ? azurerm_windows_virtual_machine.this[0] : azurerm_linux_virtual_machine.this[0]

  network_interface_ids = values(azurerm_network_interface.this[*].id)
}

resource "random_password" "this" {
  length      = 128
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
    for_each = each.value.ip_configuration

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

  tags = var.tags
}

resource "azurerm_windows_virtual_machine" "this" {
  count = local.is_windows ? 1 : 0

  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size

  admin_username = var.admin_username
  admin_password = random_password.this.result

  network_interface_ids = local.network_interface_ids

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

  tags = var.tags
}

# TODO: add diagnostic setting?
