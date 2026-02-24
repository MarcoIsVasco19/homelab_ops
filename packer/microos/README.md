# Packer: SUSE MicroOS Golden Image

This directory contains a Packer template that builds a SUSE MicroOS golden image from an upstream `qcow2` image and bakes in your personal SSH public key via cloud-init.

## Files

- `microos.pkr.hcl`: Packer build definition.
- `variables.pkr.hcl`: Input variables.
- `microos.auto.pkrvars.hcl.example`: Example variable values.
- `cloud-init/user-data.tpl`: Cloud-init user config with your SSH key.
- `cloud-init/meta-data.tpl`: Cloud-init instance metadata.

## Prerequisites

- `packer` (>= 1.10)
- `qemu-system-x86_64` and KVM support

## Usage

1. Create your vars file:

```bash
cp microos.auto.pkrvars.hcl.example microos.auto.pkrvars.hcl
```

2. Edit `microos.auto.pkrvars.hcl`:

- Set `microos_image_url` to a valid SUSE MicroOS cloud `qcow2` URL.
- Set `microos_image_checksum` to `sha256:<checksum>` (recommended).
- Set `ssh_public_key_file` to your personal public key path.
- Keep `ssh_agent_auth = true` to authenticate via your local SSH agent (default).
- If you prefer a file key, set `ssh_agent_auth = false` and provide `ssh_private_key_file`.

3. Build:

```bash
packer init .
packer validate .
packer build .
```

Built images are written under `output/`.
