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

output "private_ip_addresses" {
  description = "A map of private IP addresses for the network interfaces of this VM."
  value = {
    for k, v in azurerm_network_interface.this : k => v.private_ip_addresses
  }
}

output "identity_principal_id" {
  description = "The principal ID of the system-assigned identity of this VM. This value will be null if no identity is assigned."
  value       = try(local.vm.identity[0].principal_id, null)
}

output "identity_tenant_id" {
  description = "The tenant ID of the system-assigned identity of this VM. This value will be null if no identity is assigned."
  value       = try(local.vm.identity[0].tenant_id, null)
}
