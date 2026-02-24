variable "vm_name" {
  description = "Base name for the generated golden image VM."
  type        = string
  default     = "microos-golden"
}

variable "output_directory" {
  description = "Directory where Packer writes the built image."
  type        = string
  default     = "output"
}

variable "microos_image_url" {
  description = "URL to the upstream SUSE MicroOS qcow2 image."
  type        = string
}

variable "microos_image_checksum" {
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
  default     = "ops"
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
