variable "node_name" {
  type = string
}

variable "vm_datastore_id" {
  type        = string
  description = "Datastore where VM disks live (e.g., local-lvm)."
}

variable "snippets_datastore_id" {
  type        = string
  description = "Datastore that supports snippets (e.g., local)."
}

variable "bridge" {
  type    = string
  default = "vmbr0"
}

variable "base_image_import_from" {
  type        = string
  description = "Existing Proxmox import file_id, e.g. local:import/openSUSE-Leap-Micro.x86_64-ContainerHost-kvm-and-xen.qcow2"
}

variable "nodes" {
  description = "Map of nodes to create."
  type = map(object({
    vm_id             = number
    hostname          = string
    cores             = number
    memory_mb         = number
    disk_gb           = optional(number, 32)
    tags              = optional(list(string), [])
    user_data_file_id = string # e.g. local:snippets/k8s-cp-01-userdata.yaml
  }))
}
