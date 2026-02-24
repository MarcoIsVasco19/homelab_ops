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

  # Fedora CoreOS consumes first-boot configuration through Ignition.
  ignition_config = jsonencode({
    ignition = {
      version = "3.4.0"
    }
    passwd = {
      users = [
        {
          name              = var.ssh_username
          sshAuthorizedKeys = [local.ssh_public_key]
        }
      ]
    }
  })

  # Escape commas so QEMU parses the fw_cfg argument correctly.
  ignition_fw_cfg = "name=opt/com.coreos/config,string=${replace(local.ignition_config, ",", "\\,")}"
}

source "qemu" "fedora_coreos" {
  accelerator = "kvm"
  cpus        = var.cpus
  memory      = var.memory
  disk_size   = var.disk_size
  format      = "qcow2"
  headless    = var.headless

  # Use upstream stable Fedora CoreOS image as the base disk.
  disk_image   = true
  iso_url      = var.fedora_coreos_image_url
  iso_checksum = var.fedora_coreos_image_checksum

  output_directory = "${var.output_directory}/${var.vm_name}-${local.build_id}"
  vm_name          = "${var.vm_name}-${local.build_id}"

  qemuargs = [
    ["-fw_cfg", local.ignition_fw_cfg],
  ]

  communicator           = "ssh"
  ssh_username           = var.ssh_username
  ssh_agent_auth         = var.ssh_agent_auth
  ssh_private_key_file   = !var.ssh_agent_auth ? pathexpand(var.ssh_private_key_file) : ""
  ssh_handshake_attempts = 120
  ssh_timeout            = "20m"

  shutdown_command = "sudo systemctl poweroff"
}

build {
  name    = "fedora-coreos-golden"
  sources = ["source.qemu.fedora_coreos"]

  provisioner "shell" {
    inline = [
      "sudo truncate -s 0 /etc/machine-id",
      "sudo sync",
    ]
  }
}
