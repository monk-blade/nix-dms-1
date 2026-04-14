{ config, pkgs, inputs, ... }:
{
  networking.hostName = "vmware";

  # Keep this in sync with the version used at first install.
  system.stateVersion = "26.05";

  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # VMware guest integration.
  virtualisation.vmware.guest.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # niri-first setup: Wayland compositor + lightweight login manager.
  programs.niri.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "greeter";
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  users.users.nix = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "changeme";
  };

  networking.networkmanager.enable = true;

  programs.dank-material-shell = {
    enable = true;
    enableSystemMonitoring = true;
    niri.enableSpawn = true;
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
  ];

  services.openssh.enable = true;
  services.qemuGuest.enable = false;

  systemd.services.NetworkManager-wait-online.enable = false;
}
