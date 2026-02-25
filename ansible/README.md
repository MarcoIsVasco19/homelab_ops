# Ansible RKE2 + Rancher Setup

This directory provisions an HA RKE2 cluster on:

- Control plane: `k8s-cp-01`, `k8s-cp-02`, `k8s-cp-03`
- Workers: `k8s-wkr-01`, `k8s-wkr-02`, `k8s-wkr-03`

## Role-Based Layout

- `roles/common_prep`: host OS prep (swap, sysctl, kernel modules, prereqs).
- `roles/rke2_server`: install/configure control-plane nodes.
- `roles/rke2_agent`: install/configure worker nodes.
- `roles/rke2_addons`: Cilium Hubble + ingress-nginx chart config.
- `roles/rancher_register`: import/register cluster in Rancher.

## Playbooks

- `playbooks/prepare.yml`: runs `common_prep` on all nodes.
- `playbooks/install-rke2.yml`: installs server/agent roles by host group.
- `playbooks/addons-and-rancher.yml`: applies addon config + Rancher registration on bootstrap control plane.
- `playbooks/site.yml`: orchestration wrapper importing all playbooks above.

## Configuration

Edit:

- `inventory/hosts.yml` for node IPs.
- `inventory/group_vars/all.yml` for:
  - `rke2_token` (required, strong random secret)
  - CNI/Hubble settings
  - `rancher_import_manifest_url` or `rancher_registration_command`

## Run

```bash
cd ansible
ansible-playbook playbooks/site.yml
```

Or run in phases:

```bash
ansible-playbook playbooks/prepare.yml
ansible-playbook playbooks/install-rke2.yml
ansible-playbook playbooks/addons-and-rancher.yml
```
