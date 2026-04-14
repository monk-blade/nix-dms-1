{ config, pkgs, inputs, ... }:
{
  networking.hostName = "vmware";

  # Keep this in sync with the version used at first install.
  system.stateVersion = "26.05";

  time.timeZone = "Asia/Kolkata";
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
    initialPassword = "1121"; # Change this after first login!
  };

  networking.networkmanager.enable = true;

  programs.dank-material-shell = {
    enable = true;
    enableSystemMonitoring = true;
    
    systemd = {
      enable = true;             # Systemd service for auto-start
      restartIfChanged = true;   # Auto-restart dms.service when dank-material-shell changes
    };

    quickshell.package = pkgs.quickshell;
    enableDynamicTheming = true;       # Wallpaper-based theming (matugen)
    enableAudioWavelength = true;      # Audio visualizer (cava)
    enableCalendarEvents = true;       # Calendar integration (khal)
    enableClipboardPaste = true;       # Pasting items from the clipboard (wtype)
  };

  environment.systemPackages = with pkgs; [
    ghostty

    # Core tools
    git
    vim
    nano
    wget
    curl
    ripgrep
    fd
    jq

    # Archive/compression helpers
    unzip
    zip
    p7zip

    # Monitoring and diagnostics
    btop
    fastfetch
    pciutils
    usbutils

    # Wayland desktop utilities
    wl-clipboard
    grim
    slurp
    pavucontrol
    playerctl
  ];

  services.openssh.enable = true;
  services.qemuGuest.enable = false;

  systemd.services.NetworkManager-wait-online.enable = false;
}
