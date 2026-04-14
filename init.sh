#!/usr/bin/env bash
set -euo pipefail

# One-command installer for this flake from a NixOS live ISO.
# It will partition/format the target disk via Disko and run nixos-install.

HOST="vmware"
DISK="/dev/sda"
FLAKE_DIR=""
ASSUME_YES="false"

usage() {
  cat <<'EOF'
Usage: ./init.sh [options]

Options:
  --host <name>     NixOS flake host to install (default: vmware)
  --disk <path>     Target disk device (default: /dev/sda)
  --flake <path>    Path to flake directory (default: script directory)
  -y, --yes         Skip destructive confirmation prompt
  -h, --help        Show this help

Example:
  sudo ./init.sh --host vmware --disk /dev/sda
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --host)
      HOST="$2"
      shift 2
      ;;
    --disk)
      DISK="$2"
      shift 2
      ;;
    --flake)
      FLAKE_DIR="$2"
      shift 2
      ;;
    -y|--yes)
      ASSUME_YES="true"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$FLAKE_DIR" ]]; then
  SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
  FLAKE_DIR="$SCRIPT_DIR"
fi

if [[ ! -f "$FLAKE_DIR/flake.nix" ]]; then
  echo "Error: flake.nix not found at $FLAKE_DIR" >&2
  exit 1
fi

if [[ ! -f "$FLAKE_DIR/hosts/vmware/disko.nix" ]]; then
  echo "Error: disko file not found at $FLAKE_DIR/hosts/vmware/disko.nix" >&2
  exit 1
fi

if [[ ! -b "$DISK" ]]; then
  echo "Error: disk device $DISK not found (not a block device)." >&2
  exit 1
fi

if [[ "$ASSUME_YES" != "true" ]]; then
  echo "WARNING: This will ERASE all data on $DISK"
  read -r -p "Continue? Type 'yes' to proceed: " CONFIRM
  if [[ "$CONFIRM" != "yes" ]]; then
    echo "Aborted."
    exit 1
  fi
fi

TMP_DISKO="$(mktemp -t disko.XXXXXX.nix)"
cleanup() {
  rm -f "$TMP_DISKO"
}
trap cleanup EXIT

# Adjust disk device without mutating repository files.
sed "s|device = \"/dev/sda\";|device = \"$DISK\";|" \
  "$FLAKE_DIR/hosts/vmware/disko.nix" > "$TMP_DISKO"

echo "==> Running Disko on $DISK"
nix --experimental-features "nix-command flakes" \
  run github:nix-community/disko/latest -- \
  --mode disko "$TMP_DISKO"

echo "==> Installing NixOS host '$HOST' from $FLAKE_DIR"
nixos-install --flake "$FLAKE_DIR#$HOST"

echo "Install complete. Reboot with: sudo reboot"
