{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Terminal
    ghostty

    # Core tools
    git
    git-lfs
    vim
    neovim
    nano
    tmux
    wget
    curl
    rsync
    tree
    file
    ripgrep
    fd
    jq
    fzf
    eza
    bat

    # Dev tooling
    gcc
    gnumake
    cmake
    pkg-config
    python3
    nodejs_22
    go
    rustc
    cargo

    # Git and API workflow
    gh
    httpie

    # Archive/compression helpers
    unzip
    zip
    p7zip

    # Monitoring and diagnostics
    btop
    htop
    fastfetch
    lsof
    strace
    lm_sensors
    pciutils
    usbutils
    nmap
    mtr
    iperf3

    # Wayland desktop utilities
    wl-clipboard
    grim
    slurp
    wf-recorder
    pavucontrol
    playerctl

    # Common desktop apps for daily work
    firefox
    libreoffice
  ];
}
