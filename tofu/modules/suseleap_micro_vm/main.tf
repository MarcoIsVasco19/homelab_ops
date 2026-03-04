resource "proxmox_virtual_environment_file" "cloud_init_user_data" {
  for_each = var.cloud_init_snippets

  content_type = "snippets"
  datastore_id = var.snippets_datastore_id
  node_name    = var.node_name

  source_raw {
    data      = each.value.content
    file_name = each.value.file_name
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

  # Cloud-init userdata is uploaded by OpenTofu to snippets datastore.
  initialization {
    datastore_id      = var.snippets_datastore_id
    user_data_file_id = "${var.snippets_datastore_id}:snippets/${var.cloud_init_snippets[each.key].file_name}"

    dynamic "ip_config" {
      for_each = try(each.value.ipv4_cidr, null) == null ? [1] : []
      content {
        ipv4 {
          address = "dhcp"
        }
      }
    }

    dynamic "ip_config" {
      for_each = try(each.value.ipv4_cidr, null) != null ? [1] : []
      content {
        ipv4 {
          address = each.value.ipv4_cidr
          gateway = try(each.value.ipv4_gateway, null)
        }
      }
    }
  }

  depends_on = [proxmox_virtual_environment_file.cloud_init_user_data]
}
