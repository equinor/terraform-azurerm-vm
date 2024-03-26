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

output "data_disks" {
  value = {
    "disk1" = {
      name         = "disk-${local.name_suffix}-01"
      disk_size_gb = 1
    }
    "disk2" = {
      name         = "disk-${local.name_suffix}-02"
      disk_size_gb = 1
    }
  }
}

output "custom_data" {
  value = file("${path.module}/cloud-init.txt")
}

output "identity_ids" {
  value = [
    "/subscriptions/${local.subscription_id}/resourceGroups/${local.resource_group_name}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id-${local.name_suffix}-01",
    "/subscriptions/${local.subscription_id}/resourceGroups/${local.resource_group_name}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id-${local.name_suffix}-02"
  ]
}
