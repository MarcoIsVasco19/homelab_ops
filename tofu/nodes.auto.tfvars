node_name        = "pve01"
proxmox_endpoint = "https://192.168.2.69:8006/"

# Your storage split
snippets_datastore_id = "local"
vm_datastore_id       = "local-lvm"
bridge                = "vmbr0"

# Manually prepared openSUSE Leap Micro 6.2 image in local import storage
base_image_import_from = "local:import/openSUSE-Leap-Micro.x86_64-Default-qcow.qcow2"

nodes = {
  cp1 = {
    vm_id     = 201
    hostname  = "k8s-cp-01"
    cores     = 2
    memory_mb = 4096
    tags      = ["k8s", "cp"]
    disk_gb   = 32
    ipv4_cidr    = "192.168.2.50/24"
    ipv4_gateway = "192.168.2.254"

    # user_data_file_name = "k8s-cp-01-userdata.yaml"
  }
  cp2 = {
    vm_id     = 202
    hostname  = "k8s-cp-02"
    cores     = 2
    memory_mb = 4096
    tags      = ["k8s", "cp"]
    disk_gb   = 32
    ipv4_cidr    = "192.168.2.51/24"
    ipv4_gateway = "192.168.2.254"

    # user_data_file_name = "k8s-cp-02-userdata.yaml"
  }
  cp3 = {
    vm_id     = 203
    hostname  = "k8s-cp-03"
    cores     = 2
    memory_mb = 4096
    tags      = ["k8s", "cp"]
    disk_gb   = 32
    ipv4_cidr    = "192.168.2.52/24"
    ipv4_gateway = "192.168.2.254"

    # user_data_file_name = "k8s-cp-03-userdata.yaml"
  }
  wkr1 = {
    vm_id     = 211
    hostname  = "k8s-wkr-01"
    cores     = 4
    memory_mb = 4096
    tags      = ["k8s", "worker"]
    ipv4_cidr    = "192.168.2.53/24"
    ipv4_gateway = "192.168.2.254"

    # user_data_file_name = "k8s-wkr-01-userdata.yaml"
  }
  wkr2 = {
    vm_id     = 212
    hostname  = "k8s-wkr-02"
    cores     = 4
    memory_mb = 4096
    tags      = ["k8s", "worker"]
    ipv4_cidr    = "192.168.2.54/24"
    ipv4_gateway = "192.168.2.254"

    # user_data_file_name = "k8s-wkr-02-userdata.yaml"
  }
  # wkr3 = {
  #   vm_id     = 213
  #   hostname  = "k8s-wkr-03"
  #   cores     = 4
  #   memory_mb = 4096
  #   tags      = ["k8s", "worker"]
  #   ipv4_cidr    = "192.168.2.55/24"
  #   ipv4_gateway = "192.168.2.254"

  #   # user_data_file_id = "k8s-wkr-03-userdata.yaml"
  # }
}
