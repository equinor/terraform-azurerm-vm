output "admin_username" {
  description = "The admin username of this VM."
  value       = local.vm.admin_username
}

output "admin_password" {
  description = "The admin password of this VM."
  value       = local.vm.admin_password
  sensitive   = true
}
