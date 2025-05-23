mock_provider "azurerm" {}

run "setup_tests" {
  module {
    source = "./tests/setup-unit-tests"
  }
}

run "linux_vm" {
  command = plan

  variables {
    vm_name               = run.setup_tests.vm_name
    resource_group_name   = run.setup_tests.resource_group_name
    location              = run.setup_tests.location
    admin_username        = run.setup_tests.admin_username
    os_disk_name          = run.setup_tests.os_disk_name
    storage_blob_endpoint = run.setup_tests.storage_blob_endpoint
    network_interfaces    = run.setup_tests.network_interfaces
  }

  assert {
    condition     = length(azurerm_linux_virtual_machine.this) == 1
    error_message = "Linux VM not created"
  }

  assert {
    condition     = length(azurerm_windows_virtual_machine.this) == 0
    error_message = "Trying to create Windows VM"
  }
}

run "windows_vm" {
  command = plan

  variables {
    vm_name               = run.setup_tests.vm_name
    resource_group_name   = run.setup_tests.resource_group_name
    location              = run.setup_tests.location
    kind                  = "Windows"
    admin_username        = run.setup_tests.admin_username
    os_disk_name          = run.setup_tests.os_disk_name
    storage_blob_endpoint = run.setup_tests.storage_blob_endpoint
    network_interfaces    = run.setup_tests.network_interfaces
  }

  assert {
    condition     = length(azurerm_windows_virtual_machine.this) == 1
    error_message = "Windows VM not created"
  }

  assert {
    condition     = length(azurerm_linux_virtual_machine.this) == 0
    error_message = "Trying to create Linux VM"
  }
}

run "network_interface_nsg_association" {
  command = plan

  variables {
    vm_name               = run.setup_tests.vm_name
    resource_group_name   = run.setup_tests.resource_group_name
    location              = run.setup_tests.location
    admin_username        = run.setup_tests.admin_username
    os_disk_name          = run.setup_tests.os_disk_name
    storage_blob_endpoint = run.setup_tests.storage_blob_endpoint
    network_interfaces    = run.setup_tests.network_interfaces_with_nsg
  }

  assert {
    condition     = length(azurerm_network_interface_security_group_association.this) == 1
    error_message = "Trying to create network interface security group association"
  }
}

run "enable_system_assigned_identity" {
  command = plan

  variables {
    vm_name               = run.setup_tests.vm_name
    resource_group_name   = run.setup_tests.resource_group_name
    location              = run.setup_tests.location
    admin_username        = run.setup_tests.admin_username
    os_disk_name          = run.setup_tests.os_disk_name
    storage_blob_endpoint = run.setup_tests.storage_blob_endpoint
    network_interfaces    = run.setup_tests.network_interfaces

    system_assigned_identity_enabled = true
  }

  assert {
    condition     = length(local.vm.identity) == 1
    error_message = "System-assigned identity disabled."
  }

  assert {
    condition     = local.vm.identity[0].type == "SystemAssigned"
    error_message = "System-assigned identity disabled."
  }
}

run "disable_system_assigned_identity" {
  command = plan

  variables {
    vm_name               = run.setup_tests.vm_name
    resource_group_name   = run.setup_tests.resource_group_name
    location              = run.setup_tests.location
    admin_username        = run.setup_tests.admin_username
    os_disk_name          = run.setup_tests.os_disk_name
    storage_blob_endpoint = run.setup_tests.storage_blob_endpoint
    network_interfaces    = run.setup_tests.network_interfaces

    system_assigned_identity_enabled = false
  }

  assert {
    condition     = length(local.vm.identity) == 0
    error_message = "System-assigned identity enabled."
  }

  assert {
    condition     = output.identity_principal_id == null
    error_message = "Able to get system-assigned principal ID."
  }

  assert {
    condition     = output.identity_tenant_id == null
    error_message = "Able to get system-assigned identity tenant ID."
  }
}

run "user_assigned_identities" {
  command = plan

  variables {
    vm_name               = run.setup_tests.vm_name
    resource_group_name   = run.setup_tests.resource_group_name
    location              = run.setup_tests.location
    admin_username        = run.setup_tests.admin_username
    os_disk_name          = run.setup_tests.os_disk_name
    storage_blob_endpoint = run.setup_tests.storage_blob_endpoint
    network_interfaces    = run.setup_tests.network_interfaces

    identity_ids = run.setup_tests.identity_ids
  }

  assert {
    condition     = length(local.vm.identity) == 1
    error_message = "User-assigned identity disabled."
  }

  assert {
    condition     = local.vm.identity[0].type == "UserAssigned"
    error_message = "User-assigned identity disabled."
  }

  assert {
    condition     = length(local.vm.identity[0].identity_ids) == 2
    error_message = "Incorrect number of user-assigned identity IDs."
  }
}

run "custom_data" {
  command = plan

  variables {
    vm_name               = run.setup_tests.vm_name
    resource_group_name   = run.setup_tests.resource_group_name
    location              = run.setup_tests.location
    admin_username        = run.setup_tests.admin_username
    os_disk_name          = run.setup_tests.os_disk_name
    storage_blob_endpoint = run.setup_tests.storage_blob_endpoint
    network_interfaces    = run.setup_tests.network_interfaces

    custom_data = run.setup_tests.custom_data
  }
}

run "data_disks" {
  command = plan

  variables {
    vm_name               = run.setup_tests.vm_name
    resource_group_name   = run.setup_tests.resource_group_name
    location              = run.setup_tests.location
    admin_username        = run.setup_tests.admin_username
    os_disk_name          = run.setup_tests.os_disk_name
    storage_blob_endpoint = run.setup_tests.storage_blob_endpoint
    network_interfaces    = run.setup_tests.network_interfaces

    data_disks = run.setup_tests.data_disks
  }

  assert {
    condition     = length(azurerm_managed_disk.this) == 2 && length(azurerm_virtual_machine_data_disk_attachment.this) == 2
    error_message = "Failed to create and attach 2 data disks"
  }

  assert {
    condition     = alltrue([for k, v in azurerm_managed_disk.this : v.create_option == "Empty"])
    error_message = "Managed disk create option must be \"Empty\""
  }

  assert {
    condition     = azurerm_virtual_machine_data_disk_attachment.this["disk1"].lun == 0 && azurerm_virtual_machine_data_disk_attachment.this["disk2"].lun == 1
    error_message = "Unexpected logical unit numbers (LUNs) for data disks"
  }
}

run "encryption_at_host_enabled_true" {
  command = plan

  variables {
    vm_name                    = run.setup_tests.vm_name
    resource_group_name        = run.setup_tests.resource_group_name
    location                   = run.setup_tests.location
    admin_username             = run.setup_tests.admin_username
    os_disk_name               = run.setup_tests.os_disk_name
    storage_blob_endpoint      = run.setup_tests.storage_blob_endpoint
    network_interfaces         = run.setup_tests.network_interfaces
    encryption_at_host_enabled = true
  }

  assert {
    condition     = local.vm.encryption_at_host_enabled == true
    error_message = "Encryption at host not enabled"
  }
}

run "encryption_at_host_enabled_false" {
  command = plan

  variables {
    vm_name                    = run.setup_tests.vm_name
    resource_group_name        = run.setup_tests.resource_group_name
    location                   = run.setup_tests.location
    admin_username             = run.setup_tests.admin_username
    os_disk_name               = run.setup_tests.os_disk_name
    storage_blob_endpoint      = run.setup_tests.storage_blob_endpoint
    network_interfaces         = run.setup_tests.network_interfaces
    encryption_at_host_enabled = false
  }

  assert {
    condition     = local.vm.encryption_at_host_enabled == false
    error_message = "Encryption at host enabled"
  }
}
