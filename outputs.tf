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
