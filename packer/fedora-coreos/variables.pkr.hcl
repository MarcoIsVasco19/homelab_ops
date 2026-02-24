variable "vm_name" {
  description = "Base name for the generated Fedora CoreOS golden image VM."
  type        = string
  default     = "fedora-coreos-golden"
}

variable "output_directory" {
  description = "Directory where Packer writes the built image."
  type        = string
  default     = "output"
}

variable "fedora_coreos_image_url" {
  description = "URL to the upstream Fedora CoreOS stable qemu qcow2 image."
  type        = string
}

variable "fedora_coreos_image_checksum" {
  description = "Checksum for the upstream image. Use sha256:<value>."
  type        = string
  default     = "none"
}

variable "cpus" {
  description = "Number of vCPUs for the temporary build VM."
  type        = number
  default     = 2
}

variable "memory" {
  description = "RAM (MiB) for the temporary build VM."
  type        = number
  default     = 2048
}

variable "disk_size" {
  description = "Final disk size for the golden image."
  type        = string
  default     = "20G"
}

variable "ssh_username" {
  description = "User account that will receive your SSH key."
  type        = string
  default     = "core"
}

variable "ssh_public_key_file" {
  description = "Path to your personal SSH public key file."
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "ssh_private_key_file" {
  description = "Optional path to matching private key used by Packer during build."
  type        = string
  default     = ""
}

variable "ssh_agent_auth" {
  description = "Use SSH agent authentication for Packer communicator."
  type        = bool
  default     = true
}

variable "headless" {
  description = "Run the QEMU builder in headless mode."
  type        = bool
  default     = true
}
