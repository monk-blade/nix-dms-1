{ ... }:
{
  imports = [
    ../../profiles/vmware.nix
  ];

  networking.hostName = "vmware";

  # Keep this in sync with the version used at first install.
  system.stateVersion = "26.05";

  time.timeZone = "Asia/Kolkata";

  # VMware guest integration.
  virtualisation.vmware.guest.enable = true;
}
