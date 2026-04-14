# NixOS flake + Disko + DankMaterialShell (VMware guest)

This repository contains a basic flake setup for a NixOS VMware guest with:

- Disko for partitioning/formatting
- DankMaterialShell NixOS module
- A niri-first Wayland stack (niri + greetd)

## Files

- `flake.nix`: flake inputs and `nixosConfigurations.vmware`
- `hosts/vmware/configuration.nix`: host config (VMware guest + DMS)
- `hosts/vmware/disko.nix`: Disko layout (`/dev/sda`, EFI + ext4 root)

## Install from NixOS ISO in VMware

1. Boot the VM with NixOS ISO and get shell access.
2. Clone this repo:

```bash
git clone <your-repo-url> /mnt/nix-dms
cd /mnt/nix-dms
```

3. Partition and format using Disko:

```bash
sudo nix --experimental-features "nix-command flakes" \
  run github:nix-community/disko/latest -- \
  --mode disko ./hosts/vmware/disko.nix
```

4. Install NixOS from the flake:

```bash
sudo nixos-install --flake .#vmware
```

5. Reboot:

```bash
sudo reboot
```

## After first boot

- Log in with user `nix` and password `changeme`.
- Change the password immediately:

```bash
passwd
```

- The greeter launches `niri-session`, and DMS is set to auto-spawn under niri.

## Notes

- This config assumes the VMware virtual disk is `/dev/sda`.
- If your VM disk appears as `/dev/nvme0n1` or `/dev/vda`, update `hosts/vmware/disko.nix`.
- This setup is niri-first and does not install Plasma/SDDM.
- You can switch to unstable DMS by changing the input to:

```nix
dms.url = "github:AvengeMedia/DankMaterialShell";
```
