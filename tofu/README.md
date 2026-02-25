# tofu quickstart

This directory contains the OpenTofu stack that provisions Proxmox VMs using the `suseleap_micro_vm` module and dynamically rendered cloud-init snippets.

For full project documentation, see:
- [../README.md](../README.md)

## Daily workflow

1. Update VM definitions (first rename the `nodes.auto.tfvars.example` file to remove `.example`):
- `nodes.auto.tfvars`

2. Update cloud-init files:
- `cloud-init/templates/user-data.tpl.yaml` (single template)

3. Set SSH public keys used by cloud-init rendering in OpenTofu:

- `TF_VAR_root_ssh_public_key`
- `TF_VAR_ansible_ssh_public_key`

4. Load environment variables with direnv:

```bash
cp .envrc.local.example .envrc.local
# edit .envrc.local with your secrets
direnv allow
```

5. Run OpenTofu:

```bash
tofu init
tofu plan
tofu apply
```

## Notes

- Cloud-init snippets are rendered/uploaded by OpenTofu per-node during apply.
- Node networking defaults to DHCP. Set `ipv4_cidr` (and usually `ipv4_gateway`) per node in `nodes.auto.tfvars` to use static IPs.
- `disk_gb` defaults to `32` when omitted.

## Environment variables

Set these in `.envrc.local`:

- `TF_VAR_proxmox_api_token` (required)
- `TF_VAR_proxmox_endpoint` (optional override)
- `TF_VAR_root_ssh_public_key` (required for cloud-init)
- `TF_VAR_ansible_ssh_public_key` (required for cloud-init)
- `AWS_PROFILE` or `AWS_ACCESS_KEY_ID` + `AWS_SECRET_ACCESS_KEY` (+ optional `AWS_SESSION_TOKEN`)
- `AWS_REGION` (defaults to `eu-central-1` via `.envrc`)

For full details, see [../README.md](../README.md).

## Configure S3 backend

```bash
# backend is configured in backend.tf.
# ensure AWS creds are loaded via direnv, then:
tofu init -migrate-state
```
