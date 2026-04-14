# NixOS flake + Disko + DankMaterialShell (VMware guest)

Basic flake-parts NixOS setup with a dendritic modular layout and multi-host-ready structure:

- Disko-based partitioning and formatting
- DankMaterialShell as a NixOS module
- niri-first Wayland session with greetd
- host leaf modules + shared branch modules

## Project layout

- `flake.nix`: flake-parts root, host map, and `nixosConfigurations`
- `modules/core/*`: boot, locale, networking, and nix settings
- `modules/desktop/*`: niri/greetd/portal and DMS
- `modules/services/*`: openssh and service tuning
- `modules/users/*`: user definitions
- `modules/packages/default.nix`: compact package set
- `profiles/common.nix`: shared composition trunk
- `profiles/vmware.nix`: vmware profile trunk
- `hosts/vmware/configuration.nix`: vmware host leaf overrides
- `hosts/vmware/disko.nix`: vmware disk layout leaf
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
nano ./modules/packages/default.nix
sudo nixos-rebuild switch --flake .#vmware

# Host-specific overrides
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
- To add another host, create `hosts/<name>/configuration.nix` and `hosts/<name>/disko.nix`, then add the host entry in `flake.nix` under `hosts`.
- To use unstable DMS, set this in `flake.nix`:

```nix
dms.url = "github:AvengeMedia/DankMaterialShell";
```
