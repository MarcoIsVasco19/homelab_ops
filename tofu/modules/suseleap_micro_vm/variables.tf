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
  description = "Default Proxmox import file_id for VM disks, unless a node-specific image_import_from is provided."
}

variable "nodes" {
  description = "Map of nodes to create."
  type = map(object({
    vm_id               = number
    hostname            = string
    cores               = number
    memory_mb           = number
    disk_gb             = optional(number, 32)
    image_import_from   = optional(string)
    cloud_init_profile  = optional(string, "suse_leap_micro")
    tags                = optional(list(string), [])
    ipv4_cidr           = optional(string)
    ipv4_gateway        = optional(string)
    user_data_file_id   = optional(string)
    user_data_file_name = optional(string)
  }))
}

variable "cloud_init_snippets" {
  description = "Rendered cloud-init snippets keyed by node key."
  type = map(object({
    file_name = string
    content   = string
  }))
}
