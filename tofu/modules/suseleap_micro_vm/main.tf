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

  # Cloud-init userdata file is pre-staged in snippets datastore
  initialization {
    datastore_id      = var.snippets_datastore_id
    user_data_file_id = each.value.user_data_file_id
  }
}
