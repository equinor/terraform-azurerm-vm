locals {
  is_windows = var.kind == "Windows"
  vm         = local.is_windows ? azurerm_windows_virtual_machine.this[0] : azurerm_linux_virtual_machine.this[0]

  network_interface_security_group_associations = {
    for k, v in var.network_interfaces : k => v.network_security_group.id if v.network_security_group != null
  }

  network_interface_ids = [for v in azurerm_network_interface.this : v.id]

  admin_password = coalesce(var.admin_password, random_password.this.result)

  custom_data = var.custom_data != null ? base64encode(var.custom_data) : null

  patch_mode = var.azure_orchestrated_patching_enabled ? "AutomaticByPlatform" : "ImageDefault"

  identity_type = join(", ", compact([
    var.system_assigned_identity_enabled ? "SystemAssigned" : "",
    length(var.identity_ids) > 0 ? "UserAssigned" : ""
  ]))

  default_extensions = {
    "AzureMonitorAgent" = {
      name      = "AzureMonitor${var.kind}Agent"
      publisher = "Microsoft.Azure.Monitor"
      type      = "AzureMonitor${var.kind}Agent"

      # Install latest minor version 1.x
      type_handler_version       = "1.0"
      auto_upgrade_minor_version = true
      automatic_upgrade_enabled  = false
    }
  }

  vm_tags = merge(var.tags, var.vm_tags)
}

resource "random_password" "this" {
  length      = local.is_windows ? 123 : 72
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

  tags = var.tags

  dynamic "ip_configuration" {
    for_each = each.value.ip_configurations

    content {
      name                          = ip_configuration.value.name
      subnet_id                     = ip_configuration.value.subnet_id
      private_ip_address_allocation = "Dynamic"

      # A public IP address should not be attached directly to a NIC.

      # The first configuration should be set as primary.
      primary = index(each.value.ip_configurations, ip_configuration.value) == 0
    }
  }
}

resource "azurerm_network_interface_security_group_association" "this" {
  for_each = local.network_interface_security_group_associations

  network_interface_id      = azurerm_network_interface.this[each.key].id
  network_security_group_id = each.value
}

resource "azurerm_linux_virtual_machine" "this" {
  count = local.is_windows ? 0 : 1

  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size

  computer_name                   = coalesce(var.computer_name, var.vm_name)
  admin_username                  = var.admin_username
  admin_password                  = local.admin_password
  disable_password_authentication = false

  network_interface_ids = local.network_interface_ids

  custom_data = local.custom_data

  bypass_platform_safety_checks_on_user_schedule_enabled = var.azure_orchestrated_patching_enabled

  patch_assessment_mode = local.patch_mode
  patch_mode            = local.patch_mode

  os_disk {
    name                 = var.os_disk_name
    caching              = var.os_disk_caching
    disk_size_gb         = var.os_disk_size_gb
    storage_account_type = var.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = coalesce(var.source_image_publisher, "canonical")
    offer     = coalesce(var.source_image_offer, "0001-com-ubuntu-minimal-focal")
    sku       = coalesce(var.source_image_sku, "minimal-20_04-lts-gen2")
    version   = coalesce(var.source_image_version, "latest")
  }

  boot_diagnostics {
    storage_account_uri = var.storage_blob_endpoint
  }

  dynamic "identity" {
    for_each = local.identity_type != "" ? [0] : []

    content {
      type         = local.identity_type
      identity_ids = var.identity_ids
    }
  }

  tags = local.vm_tags
}

resource "azurerm_windows_virtual_machine" "this" {
  count = local.is_windows ? 1 : 0

  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size

  computer_name  = coalesce(var.computer_name, substr(var.vm_name, 0, 15))
  admin_username = var.admin_username
  admin_password = local.admin_password

  network_interface_ids = local.network_interface_ids

  custom_data = local.custom_data

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
    disk_size_gb         = var.os_disk_size_gb
  }

  source_image_reference {
    publisher = coalesce(var.source_image_publisher, "MicrosoftWindowsServer")
    offer     = coalesce(var.source_image_offer, "WindowsServer")
    sku       = coalesce(var.source_image_sku, "2022-datacenter-azure-edition")
    version   = coalesce(var.source_image_version, "latest")
  }

  boot_diagnostics {
    storage_account_uri = var.storage_blob_endpoint
  }

  dynamic "identity" {
    for_each = local.identity_type != "" ? [0] : []

    content {
      type         = local.identity_type
      identity_ids = var.identity_ids
    }
  }

  tags = local.vm_tags
}

resource "azurerm_managed_disk" "this" {
  for_each = var.data_disks

  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  location             = var.location
  create_option        = each.value.create_option
  disk_size_gb         = each.value.disk_size_gb
  storage_account_type = each.value.storage_account_type
  hyper_v_generation   = each.value.hyper_v_generation

  tags = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "this" {
  for_each = var.data_disks

  virtual_machine_id = local.vm.id
  managed_disk_id    = azurerm_managed_disk.this[each.key].id
  caching            = each.value.caching
  lun                = coalesce(each.value.lun, index(values(var.data_disks), each.value))
}

resource "azurerm_virtual_machine_extension" "this" {
  for_each = merge(local.default_extensions, var.extensions)

  virtual_machine_id         = local.vm.id
  name                       = each.value.name
  publisher                  = each.value.publisher
  type                       = each.value.type
  type_handler_version       = each.value.type_handler_version
  auto_upgrade_minor_version = each.value.auto_upgrade_minor_version
  automatic_upgrade_enabled  = each.value.automatic_upgrade_enabled
}
