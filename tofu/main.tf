module "fcos_nodes" {
  source = "./modules/fcos_vm"

  node_name             = var.node_name
  vm_datastore_id       = var.vm_datastore_id       # local-lvm
  snippets_datastore_id = var.snippets_datastore_id # local
  bridge                = var.bridge

  base_image_import_from = var.base_image_import_from
  snippets_abs_path      = var.snippets_abs_path

  nodes = var.nodes
}