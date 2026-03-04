locals {
  cloud_init_snippets = {
    for node_key, node in var.nodes : node_key => {
      file_name = coalesce(
        try(node.user_data_file_name, null),
        try(element(reverse(split("/", node.user_data_file_id)), 0), null),
        "${node.hostname}-userdata.yaml"
      )
      content = templatefile("${path.module}/cloud-init/templates/user-data.tpl.yaml", {
        hostname               = node.hostname
        root_ssh_public_key    = var.root_ssh_public_key
        ansible_ssh_public_key = var.ansible_ssh_public_key
      })
    }
  }
}

module "suseleap_micro_nodes" {
  source = "./modules/suseleap_micro_vm"

  node_name             = var.node_name
  vm_datastore_id       = var.vm_datastore_id       # local-lvm
  snippets_datastore_id = var.snippets_datastore_id # local
  bridge                = var.bridge

  base_image_import_from = var.base_image_import_from
  nodes                  = var.nodes
  cloud_init_snippets    = local.cloud_init_snippets
}
