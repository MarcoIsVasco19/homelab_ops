packer {
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = ">= 1.1.2"
    }
  }
}

locals {
  build_id       = regex_replace(timestamp(), "[- TZ:]", "")
  ssh_public_key = trimspace(file(pathexpand(var.ssh_public_key_file)))
}

source "qemu" "microos" {
  accelerator = "kvm"
  cpus        = var.cpus
  memory      = var.memory
  disk_size   = var.disk_size
  format      = "qcow2"
  headless    = var.headless

  # Use upstream cloud image as the base disk.
  disk_image   = true
  iso_url      = var.microos_image_url
  iso_checksum = var.microos_image_checksum

  output_directory = "${var.output_directory}/${var.vm_name}-${local.build_id}"
  vm_name          = "${var.vm_name}-${local.build_id}"

  communicator           = "ssh"
  ssh_username           = var.ssh_username
  ssh_agent_auth         = var.ssh_agent_auth
  ssh_private_key_file   = !var.ssh_agent_auth ? pathexpand(var.ssh_private_key_file) : ""
  ssh_handshake_attempts = 120
  ssh_timeout            = "20m"

  # Provide a NoCloud seed so cloud-init creates the user and key.
  cd_label = "cidata"
  cd_content = {
    "meta-data" = templatefile("${path.root}/cloud-init/meta-data.tpl", {
      instance_id    = var.vm_name
      local_hostname = var.vm_name
    })
    "user-data" = templatefile("${path.root}/cloud-init/user-data.tpl", {
      ssh_username   = var.ssh_username
      ssh_public_key = local.ssh_public_key
    })
  }

  shutdown_command = "sudo systemctl poweroff"
}

build {
  name    = "suse-microos-golden"
  sources = ["source.qemu.microos"]

  provisioner "shell" {
    inline = [
      "sudo cloud-init status --wait",
      "sudo cloud-init clean --logs",
      "sudo truncate -s 0 /etc/machine-id",
      "sudo sync",
    ]
  }
}
