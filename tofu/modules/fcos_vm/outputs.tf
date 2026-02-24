output "vm_ids" {
  value = { for k, v in proxmox_virtual_environment_vm.vm : k => v.vm_id }
}

output "snippets" {
  value = { for k, v in proxmox_virtual_environment_file.ignition : k => v.file_name }
}