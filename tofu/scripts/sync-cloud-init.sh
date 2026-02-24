#!/usr/bin/env bash
set -euo pipefail

SRC_DIR="${SRC_DIR:-./cloud-init}"
PVE_HOST="${PVE_HOST:-}"
PVE_USER="${PVE_USER:-root}"
DEST_DIR="${DEST_DIR:-/var/lib/vz/snippets}"

usage() {
  cat <<USAGE
Usage: $(basename "$0") --host <proxmox-host-or-ip> [--user root] [--src ./cloud-init] [--dest /var/lib/vz/snippets]

Env alternatives:
  PVE_HOST, PVE_USER, SRC_DIR, DEST_DIR
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --host) PVE_HOST="$2"; shift 2 ;;
    --user) PVE_USER="$2"; shift 2 ;;
    --src) SRC_DIR="$2"; shift 2 ;;
    --dest) DEST_DIR="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage; exit 1 ;;
  esac
done

if [[ -z "$PVE_HOST" ]]; then
  echo "PVE host is required." >&2
  usage
  exit 1
fi

if [[ ! -d "$SRC_DIR" ]]; then
  echo "Source dir not found: $SRC_DIR" >&2
  exit 1
fi

shopt -s nullglob
files=("$SRC_DIR"/*.yaml "$SRC_DIR"/*.yml)
if [[ ${#files[@]} -eq 0 ]]; then
  echo "No .yaml/.yml files found in $SRC_DIR" >&2
  exit 1
fi

echo "Syncing ${#files[@]} cloud-init file(s) to ${PVE_USER}@${PVE_HOST}:${DEST_DIR}"
rsync -av --progress --chmod=F644 "${files[@]}" "${PVE_USER}@${PVE_HOST}:${DEST_DIR}/"

echo "Done. Example file_id values to use in tfvars:"
for f in "${files[@]}"; do
  bn="$(basename "$f")"
  echo "  local:snippets/${bn}"
done
