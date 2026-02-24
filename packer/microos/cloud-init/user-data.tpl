#cloud-config
users:
  - default
  - name: ${ssh_username}
    groups: [wheel]
    sudo: "ALL=(ALL) NOPASSWD:ALL"
    shell: /bin/bash
    lock_passwd: true
    ssh_authorized_keys:
      - ${ssh_public_key}

disable_root: true
ssh_pwauth: false
