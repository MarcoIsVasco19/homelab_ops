resource "proxmox_virtual_environment_file" "ignition" {
  for_each     = var.nodes
  node_name    = var.node_name
  datastore_id = var.snippets_datastore_id
  content_type = "snippets"

  # Upload local ignition file (tracked in git) as a Proxmox snippet
  source_file {
    path = each.value.ignition_path
  }

}

resource "proxmox_virtual_environment_vm" "vm" {
  for_each  = var.nodes
  name      = each.value.hostname
  node_name = var.node_name
  vm_id     = each.value.vm_id
  tags      = each.value.tags

  operating_system {
    type = "l26"
  }

  cpu {
    cores = each.value.cores
    type  = "host"
  }

  memory {
    dedicated = each.value.memory_mb
  }

  agent {
    enabled = false
  }

  network_device {
    bridge = var.bridge
  }

  disk {
    datastore_id = var.vm_datastore_id
    interface    = "scsi0"
    discard      = "on"
    ssd          = true
    size         = each.value.disk_gb

    # Use your manually prepared base image (import content)
    import_from = var.base_image_import_from
  }

  # Pass ignition via QEMU fw_cfg, referencing the snippet on the Proxmox node
  kvm_arguments = "-fw_cfg name=opt/com.coreos/config,file=${var.snippets_abs_path}/${proxmox_virtual_environment_file.ignition[each.key].file_name}"
}
