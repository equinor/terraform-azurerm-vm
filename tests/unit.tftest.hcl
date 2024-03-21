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

run "custom_data" {
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
    custom_data           = run.setup_tests.custom_data
  }
}
