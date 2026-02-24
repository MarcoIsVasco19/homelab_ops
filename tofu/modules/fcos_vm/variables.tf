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
  description = "Existing Proxmox import file_id, e.g. local:import/fcos-stable.qcow2"
}

variable "snippets_abs_path" {
  type        = string
  default     = "/var/lib/vz/snippets"
  description = "Absolute node path where snippet files live for the snippets datastore (local)."
}

variable "nodes" {
  description = "Map of nodes to create."
  type = map(object({
    vm_id              = number
    hostname           = string
    cores              = number
    memory_mb          = number
    disk_gb            = optional(number, 20)
    tags               = optional(list(string), [])
    ignition_file_name = string # e.g. k8s-cp-01.ign
  }))
}
