# homelab_ops
Infrastructure-as-Code for homelab provisioning on Proxmox using OpenTofu.

## What this repo does

The `tofu/` stack creates Proxmox VMs from an imported qcow2 image and configures them with cloud-init snippets.

Current default target:
- openSUSE Leap Micro 6.2
- Proxmox provider: `bpg/proxmox`
- Module in use: `tofu/modules/suseleap_micro_vm`

## Repository layout

- `tofu/` OpenTofu root module
- `tofu/modules/suseleap_micro_vm/` VM module (cloud-init based)
- `tofu/cloud-init/templates/` cloud-init template source files
- `tofu/cloud-init/rendered/` generated per-node cloud-init files
- `tofu/scripts/render-cloud-init.sh` renders per-node cloud-init files from template + `nodes.auto.tfvars`
- `tofu/scripts/sync-cloud-init.sh` sync helper to upload rendered files to Proxmox snippets storage
- `tofu/nodes.auto.tfvars` environment-specific VM definitions

## Prerequisites

- OpenTofu installed (`tofu`)
- Access to a Proxmox node/API endpoint
- Proxmox API token with VM and datastore permissions
- openSUSE Leap Micro qcow2 image already imported into Proxmox datastore
- `rsync` and SSH access to the Proxmox node (for syncing cloud-init files)

## Environment management with direnv

> [!NOTE]
>  For direnv to work properly it needs to be hooked into the shell. Each shell has its own extension mechanism.
>
>  Once the hook is configured, restart your shell for direnv to be activated.
>
>  #### BASH
>  Add the following line at the end of the ~/.bashrc file:
>
>  ```bash
>  eval "$(direnv hook bash)"
>  ```

In `tofu/`, environment variables are managed with `direnv`.

```bash
cd tofu
cp .envrc.local.example .envrc.local
# edit .envrc.local with your real values
direnv allow
```

Make sure it appears even after rvm, git-prompt and other shell extensions that manipulate the prompt.

OpenTofu reads the Proxmox token from `TF_VAR_proxmox_api_token`.

AWS credentials/profile in `.envrc.local` are used for the S3 backend.

## Environment variables

Set these in `tofu/.envrc.local` (recommended) and run `direnv allow`.

- `TF_VAR_proxmox_api_token` (required):
Proxmox API token used by the `bpg/proxmox` provider.
Example: `root@pam!tofu=...`

- `TF_VAR_proxmox_endpoint` (optional):
Overrides Proxmox API endpoint if not set in `nodes.auto.tfvars`.
Example: `https://192.168.2.69:8006/`

- `AWS_PROFILE` (recommended for S3 backend):
AWS named profile used for backend auth.
Alternative: set static keys below instead of profile.

- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN` (optional):
Static/temporary AWS credentials for S3 backend.
Use these when not using `AWS_PROFILE`.

- `AWS_REGION` (optional):
Default AWS region used for backend calls.
Defaults to `eu-central-1` in `tofu/.envrc` if unset.

- `AWS_EC2_METADATA_DISABLED`:
Set to `true` in `tofu/.envrc` to avoid local IMDS credential lookup noise.

- `SSH_PUB_KEY_FILE` (optional):
Path to SSH public key used by cloud-init renderer.
Default: `~/.ssh/id_ed25519.pub`

- `SSH_PUBLIC_KEY` (optional):
Inline SSH public key used by cloud-init renderer.
If set, it takes precedence over `SSH_PUB_KEY_FILE`.

## First-time setup

1. Edit VM settings in `tofu/nodes.auto.tfvars`
2. Set `base_image_import_from` to your imported qcow2 file ID
3. Render + sync cloud-init files to Proxmox snippets:

```bash
cd tofu
./scripts/sync-cloud-init.sh --host 1.2.3.4 --render
```

`render-cloud-init.sh` reads SSH key from `SSH_PUBLIC_KEY` or `SSH_PUB_KEY_FILE` (default `~/.ssh/id_ed25519.pub`).

4. Ensure each node’s `user_data_file_id` in `nodes.auto.tfvars` matches uploaded snippet file names (for datastore `local`, format is `local:snippets/<file>.yaml`)

## Deploy

```bash
cd tofu
tofu init
tofu plan
tofu apply
```

## Remote state in AWS S3

NOTE: This can be done in Azure Storage-Accounts as well using the guide [here](https://opentofu.org/docs/language/settings/backends/azurerm/).

State can be moved from local files to S3 for safer team usage.

1. Create an S3 bucket for state (versioning recommended).
2. (Optional) Create a DynamoDB table for state locking.
3. Configure backend settings in `tofu/backend.tf`.
4. Load AWS credentials via `direnv` (`.envrc.local`).
5. Migrate state:

```bash
cd tofu
tofu init -migrate-state
```

After migration, state is stored in S3 at the configured `bucket` + `key`.

## Common operations

- Upload updated cloud-init files:

```bash
cd tofu
./scripts/sync-cloud-init.sh --host 1.2.3.4 --render
```

- Add another VM:
Edit `tofu/nodes.auto.tfvars` under `nodes` with a unique `vm_id`, hostname, sizing, tags, and `user_data_file_id`.

## Notes

- `disk_gb` defaults to `32` if omitted.
- Existing VMs cannot be shrunk by Proxmox. If a plan tries to shrink disk, set `disk_gb` to current size or larger.
- For local snippets datastore, files are typically stored at `/var/lib/vz/snippets` on the Proxmox node.
