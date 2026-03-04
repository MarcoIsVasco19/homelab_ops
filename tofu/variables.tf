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
  description = "Default Proxmox import file_id used for VM disks, unless node.image_import_from is set."
}

variable "root_ssh_public_key" {
  type        = string
  description = "SSH public key for root user in cloud-init."
}

variable "ansible_ssh_public_key" {
  type        = string
  description = "SSH public key for ansible user in cloud-init."
}

variable "nodes" {
  type = map(object({
    vm_id               = number
    hostname            = string
    cores               = number
    memory_mb           = number
    disk_gb             = optional(number, 32)
    image_import_from   = optional(string) # optional per-node image override
    cloud_init_profile  = optional(string, "suse_leap_micro")
    tags                = optional(list(string), [])
    ipv4_cidr           = optional(string) # e.g. 192.168.2.101/24; defaults to DHCP when omitted
    ipv4_gateway        = optional(string) # e.g. 192.168.2.1; used with ipv4_cidr
    user_data_file_id   = optional(string) # deprecated: used only to derive file name
    user_data_file_name = optional(string)
  }))

  validation {
    condition = alltrue([
      for _, node in var.nodes : contains(
        ["suse_leap_micro", "suse_leap_16"],
        try(node.cloud_init_profile, "suse_leap_micro")
      )
    ])
    error_message = "nodes[*].cloud_init_profile must be one of: suse_leap_micro, suse_leap_16."
  }
}
