# Packer Golden Images

This directory now includes two independent Packer targets:

- `./microos`: SUSE MicroOS golden image with cloud-init key injection.
- `./fedora-coreos`: Fedora CoreOS stable golden image with Ignition key injection.

## Prerequisites

- `packer` (>= 1.10)
- `qemu-system-x86_64` and KVM support

## Build SUSE MicroOS

```bash
cd packer/microos
cp microos.auto.pkrvars.hcl.example microos.auto.pkrvars.hcl
packer init .
packer validate .
packer build .
```

See `packer/microos/README.md` for MicroOS-specific variable details.

## Build Fedora CoreOS Stable

```bash
cd packer/fedora-coreos
cp fedora-coreos.auto.pkrvars.hcl.example fedora-coreos.auto.pkrvars.hcl
packer init .
packer validate .
packer build .
```

See `packer/fedora-coreos/README.md` for Fedora CoreOS-specific variable details.
