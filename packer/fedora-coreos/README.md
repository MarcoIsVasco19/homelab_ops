# Packer: Fedora CoreOS Stable Golden Image

This directory contains a Packer template that builds a Fedora CoreOS stable golden image from an upstream `qcow2` image and bakes in your personal SSH public key.

Fedora CoreOS uses Ignition, so this template injects your key through QEMU `fw_cfg` on first boot.

## Files

- `fedora-coreos.pkr.hcl`: Packer build definition.
- `variables.pkr.hcl`: Input variables.
- `fedora-coreos.auto.pkrvars.hcl.example`: Example variable values.

## Prerequisites

- `packer` (>= 1.10)
- `qemu-system-x86_64` and KVM support
- `qemu-img`

## Usage

1. Create your vars file:

```bash
cp fedora-coreos.auto.pkrvars.hcl.example fedora-coreos.auto.pkrvars.hcl
```

2. Edit `fedora-coreos.auto.pkrvars.hcl`:

- Set `fedora_coreos_image_url` to the stable stream image you want.
- Set `fedora_coreos_image_checksum` to `sha256:<checksum>` (recommended).
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
