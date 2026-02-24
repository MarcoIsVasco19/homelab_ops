variable "proxmox_endpoint"  {type = string }
variable "proxmox_api_token" { type = string }

variable "proxmox_ssh_user" { type = string }
variable "proxmox_ssh_private_key_path" { type = string }

variable "node_name" { type = string }

variable "vm_datastore_id" { type = string }
variable "snippets_datastore_id" { type = string }

variable "bridge" { 
  type = string
  default = "vmbr0" 
}

variable "base_image_import_from" {
  type        = string
  description = "e.g. local:import/fcos-stable.qcow2"
}

# For Proxmox 'local' snippets, this is usually correct:
variable "snippets_abs_path" {
  type    = string
  default = "/var/lib/vz/snippets"
}

variable "nodes" {
  type = map(object({
    vm_id         = number
    hostname      = string
    cores         = number
    memory_mb     = number
    disk_gb       = optional(number, 20)
    tags          = optional(list(string), [])
    ignition_path = string
  }))
}