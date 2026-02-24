terraform {
  required_version = ">= 1.6.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.91.0"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = true

  # Needed for snippets upload (SSH-based)
  ssh {
    username    = var.proxmox_ssh_user
    private_key = file(var.proxmox_ssh_private_key_path)
  }
}