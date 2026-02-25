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
    tags                = optional(list(string), [])
    ipv4_cidr           = optional(string) # e.g. 192.168.2.101/24; defaults to DHCP when omitted
    ipv4_gateway        = optional(string) # e.g. 192.168.2.1; used with ipv4_cidr
    user_data_file_id   = optional(string) # deprecated: used only to derive file name
    user_data_file_name = optional(string)
  }))
}
