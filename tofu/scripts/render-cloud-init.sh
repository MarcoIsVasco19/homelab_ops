#!/usr/bin/env bash
set -euo pipefail

TFVARS_FILE="${TFVARS_FILE:-./nodes.auto.tfvars}"
TEMPLATE_FILE="${TEMPLATE_FILE:-./cloud-init/templates/user-data.tpl.yaml}"
OUT_DIR="${OUT_DIR:-./cloud-init/rendered}"
SSH_PUB_KEY="${SSH_PUBLIC_KEY:-}"
SSH_PUB_KEY_FILE="${SSH_PUB_KEY_FILE:-$HOME/.ssh/id_ed25519.pub}"

usage() {
  cat <<USAGE
Usage: $(basename "$0") [--tfvars ./nodes.auto.tfvars] [--template ./cloud-init/templates/user-data.tpl.yaml] [--out-dir ./cloud-init/rendered] [--ssh-pub-key 'ssh-ed25519 ...'] [--ssh-pub-key-file ~/.ssh/id_ed25519.pub]
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tfvars) TFVARS_FILE="$2"; shift 2 ;;
    --template) TEMPLATE_FILE="$2"; shift 2 ;;
    --out-dir) OUT_DIR="$2"; shift 2 ;;
    --ssh-pub-key) SSH_PUB_KEY="$2"; shift 2 ;;
    --ssh-pub-key-file) SSH_PUB_KEY_FILE="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage; exit 1 ;;
  esac
done

if [[ ! -f "$TFVARS_FILE" ]]; then
  echo "tfvars file not found: $TFVARS_FILE" >&2
  exit 1
fi

if [[ ! -f "$TEMPLATE_FILE" ]]; then
  echo "template file not found: $TEMPLATE_FILE" >&2
  exit 1
fi

if [[ -z "$SSH_PUB_KEY" ]]; then
  if [[ -f "$SSH_PUB_KEY_FILE" ]]; then
    SSH_PUB_KEY="$(<"$SSH_PUB_KEY_FILE")"
  fi
fi

if [[ -z "$SSH_PUB_KEY" ]]; then
  echo "No SSH public key found. Provide --ssh-pub-key or --ssh-pub-key-file." >&2
  exit 1
fi

mkdir -p "$OUT_DIR"

mapfile -t entries < <(
  awk '
    BEGIN { in_nodes=0; in_obj=0; node=""; hostname=""; fileid="" }
    /^[[:space:]]*#/ { next }
    /^[[:space:]]*nodes[[:space:]]*=[[:space:]]*{/ { in_nodes=1; next }
    {
      if (!in_nodes) next

      if (!in_obj && match($0, /^[[:space:]]*([A-Za-z0-9_-]+)[[:space:]]*=[[:space:]]*{/, m)) {
        in_obj=1
        node=m[1]
        hostname=""
        fileid=""
        next
      }

      if (in_obj && match($0, /hostname[[:space:]]*=[[:space:]]*"([^"]+)"/, m)) {
        hostname=m[1]
      }

      if (in_obj && match($0, /user_data_file_id[[:space:]]*=[[:space:]]*"([^"]+)"/, m)) {
        fileid=m[1]
      }

      if (in_obj && $0 ~ /^[[:space:]]*}/) {
        if (hostname != "" && fileid != "") {
          gsub(/^.*snippets\//, "", fileid)
          print node "|" hostname "|" fileid
        }
        in_obj=0
        node=""
        hostname=""
        fileid=""
        next
      }

      if (!in_obj && $0 ~ /^[[:space:]]*}/) {
        in_nodes=0
      }
    }
  ' "$TFVARS_FILE"
)

if [[ ${#entries[@]} -eq 0 ]]; then
  echo "No node entries with hostname + user_data_file_id found in $TFVARS_FILE" >&2
  exit 1
fi

for entry in "${entries[@]}"; do
  node_key="${entry%%|*}"
  rest="${entry#*|}"
  hostname="${rest%%|*}"
  out_file_name="${rest##*|}"
  out_path="$OUT_DIR/$out_file_name"

  awk -v host="$hostname" -v key="$SSH_PUB_KEY" '
    {
      gsub("__HOSTNAME__", host)
      gsub("__SSH_PUBLIC_KEY__", key)
      print
    }
  ' "$TEMPLATE_FILE" > "$out_path"

  echo "Rendered $out_path for node $node_key ($hostname)"
done
