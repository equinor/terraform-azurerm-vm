output "vm_name" {
  value = local.vm_name
}

output "resource_group_name" {
  value = local.resource_group_name
}

output "location" {
  value = "northeurope"
}

output "admin_username" {
  value = "azureadminuser"
}

output "os_disk_name" {
  value = local.os_disk_name
}

output "storage_blob_endpoint" {
  value = local.storage_blob_endpoint
}

output "network_interfaces" {
  value = {
    "default" = {
      name = local.nic_name

      ip_configurations = [
        {
          name      = "ipconfig1"
          subnet_id = local.subnet_id
        }
      ]
    }
  }
}
