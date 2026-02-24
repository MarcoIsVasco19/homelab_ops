terraform {
  backend "s3" {
    bucket  = "mzansi-homelab-opentofu-state"
    key     = "homelab/proxmox/terraform.tfstate"
    region  = "eu-central-1"
    encrypt = true
  }
}
