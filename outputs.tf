output "vm_name" {
  description = "The name of this VM."
  value       = local.vm.name
}

output "vm_id" {
  description = "The ID of this VM."
  value       = local.vm.id
}

output "admin_username" {
  description = "The admin username of this VM."
  value       = local.vm.admin_username
}

output "admin_password" {
  description = "The admin password of this VM."
  value       = local.vm.admin_password
  sensitive   = true
}

output "network_interface_private_ip_addresses" {
  description = "A map of network interface private IP addresses."
  value = {
    for k, v in azurerm_network_interface.this : k => v.private_ip_address
  }
}
