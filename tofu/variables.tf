variable "proxmox_endpoint" { type = string }
variable "proxmox_api_token" { type = string }

variable "node_name" { type = string }

variable "vm_datastore_id" { type = string }
variable "snippets_datastore_id" { type = string }

variable "bridge" {
  type    = string
  default = "vmbr0"
}

variable "base_image_import_from" {
  type        = string
  description = "e.g. local:import/openSUSE-Leap-Micro.x86_64-ContainerHost-kvm-and-xen.qcow2"
}

variable "nodes" {
  type = map(object({
    vm_id             = number
    hostname          = string
    cores             = number
    memory_mb         = number
    disk_gb           = optional(number, 32)
    tags              = optional(list(string), [])
    user_data_file_id = string
  }))
}
