# NixOS flake + Disko + DankMaterialShell (VMware guest)

Basic NixOS flake for a VMware guest with:

- Disko-based partitioning and formatting
- DankMaterialShell as a NixOS module
- niri-first Wayland session with greetd

## Project layout

- `flake.nix`: flake inputs and `nixosConfigurations.vmware`
- `hosts/vmware/configuration.nix`: host settings (VMware, niri, DMS, packages)
- `hosts/vmware/disko.nix`: disk layout (EFI + ext4 root)
- `init.sh`: one-command install helper for live ISO

## Quick install (recommended)

From NixOS live ISO shell:

```bash
git clone https://github.com/monk-blade/nix-dms-1
cd nix-dms-1
chmod +x ./init.sh
sudo ./init.sh --host vmware --disk /dev/sda
sudo reboot
```

Install helper options:

- `--host <name>`: flake host (default: `vmware`)
- `--disk <path>`: target disk (default: `/dev/sda`)
- `--flake <path>`: flake directory (default: script directory)
- `-y` or `--yes`: skip destructive confirmation

## Manual install

1. Boot VM with NixOS ISO and open a shell.
2. Clone repository:

```bash
git clone https://github.com/monk-blade/nix-dms-1
cd nix-dms-1
```

3. Partition and format using Disko:

```bash
sudo nix --experimental-features "nix-command flakes" \
  run github:nix-community/disko/latest -- \
  --mode disko ./hosts/vmware/disko.nix
```

4. Install from flake:

```bash
sudo nixos-install --flake .#vmware
```

5. Reboot:

```bash
sudo reboot
```

## First boot

- Login user: `nix`
- Initial password: `1121`
- Change password immediately:

```bash
passwd
```

The greeter launches `niri-session`, and DMS auto-start is handled by systemd.

## Modify and rebuild on installed OS

Clone to the installed system and apply changes iteratively:

```bash
git clone https://github.com/monk-blade/nix-dms-1 ~/nix-dms
cd ~/nix-dms
nano ./hosts/vmware/configuration.nix
sudo nixos-rebuild switch --flake .#vmware
```

Common commands:

```bash
# Build only (no activation)
nix build .#nixosConfigurations.vmware.config.system.build.toplevel

# Activate for current boot only
sudo nixos-rebuild test --flake .#vmware

# Activate on next reboot
sudo nixos-rebuild boot --flake .#vmware

# Update flake.lock
nix flake update
```

## Notes

- Default disk in this repo is `/dev/sda`.
- If your VM uses `/dev/nvme0n1` or `/dev/vda`, adjust `hosts/vmware/disko.nix` or pass `--disk` to `init.sh`.
- This profile is niri-first and does not install Plasma or SDDM.
- Quickshell is pinned to `pkgs.quickshell` to avoid heavy source builds on low-resource VMs.
- To use unstable DMS, set this in `flake.nix`:

```nix
dms.url = "github:AvengeMedia/DankMaterialShell";
```
