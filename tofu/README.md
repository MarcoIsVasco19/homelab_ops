# tofu quickstart

This directory contains the OpenTofu stack that provisions Proxmox VMs using the `suseleap_micro_vm` module and cloud-init snippets.

For full project documentation, see:
- [../README.md](../README.md)

## Daily workflow

1. Update VM definitions (first rename the `nodes.auto.tfvars.example` file to remove `.example`):
- `nodes.auto.tfvars`

2. Update cloud-init files:
- `cloud-init/templates/user-data.tpl.yaml` (single template)

3. Sync cloud-init files to Proxmox snippets datastore:

```bash
./scripts/sync-cloud-init.sh --host 1.2.3.4 --render
```

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

- `user_data_file_id` values in `nodes.auto.tfvars` must match synced snippet names, e.g. `local:snippets/k8s-cp-01-userdata.yaml`.
- `disk_gb` defaults to `32` when omitted.
- Per-node cloud-init files are rendered into `cloud-init/rendered/` by `scripts/render-cloud-init.sh`.
- Renderer reads SSH key from `SSH_PUBLIC_KEY` or `SSH_PUB_KEY_FILE` (defaults to `~/.ssh/id_ed25519.pub`).

## Configure S3 backend

```bash
# backend is configured in backend.tf.
# ensure AWS creds are loaded via direnv, then:
tofu init -migrate-state
```
