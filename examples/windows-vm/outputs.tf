output "vm_admin_username" {
  value = module.vm.admin_username
}

output "vm_admin_password" {
  value     = module.vm.admin_password
  sensitive = true
}
