##
## Programs etc, that can be specified easily
##

{
  config,
  pkgs,
  inputs,
  pkgsUnstable,
  ...
}:
{

  nixpkgs.config = {
    allowUnfree = true;
  };

  # this allows you to access `pkgsUnstable` anywhere in your config https://discourse.nixos.org/t/mixing-stable-and-unstable-packages-on-flake-based-nixos-system/50351/4
  _module.args.pkgsUnstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    inherit (config.nixpkgs) config;
  };

  programs = {
    adb.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;  # caches nix develop shells so they load instantly
    };
    steam.enable = true;
    steam.package = pkgs.steam.override {
      extraArgs = "-system-composer";
    };
    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [
      # Add any missing dynamic libraries for unpackaged programs
      # here, NOT in environment.systemPackages
      uv
    ];
  };

  environment.systemPackages = with pkgs; [
    anki
    ansible
    inputs.humble-manager.packages.${pkgs.stdenv.system}.humble-manager    arandr # gui diplay manager
    autoconf # make i think?
    automake
    bashmount
    bat
    brightnessctl
    cliphist
    clang-tools
    claude-code
    claude-monitor
    discord
    direnv
    bolt-launcher # runescape
    efibootmgr
    emacs
    feh # image viewer
    firefox
    gcc
    git
    gjs
    glib
    google-chrome
    gparted
    gnome-disk-utility
    ghostty
    htop
    fontforge-gtk
    imagemagick
    inotify-tools
    jdk17_headless
    jq
    kdePackages.kate
    kitty
    krb5
    libreoffice
    # lutris
    maim # screenshots
    nano
    nix-direnv
    nautilus
    ncdu
    nemo-with-extensions
    nemo-preview
    neofetch
    neovim
    nixos-anywhere
    libnotify
    kicad
    networkmanagerapplet
    nix-prefetch-scripts
    # nixfmt
    nixfmt-rfc-style
    nnn
    ntfs3g
    obsidian
    openconnect
    p3x-onenote
    pamixer # volume
    pavucontrol # gui sound manager from pulseaudio
    playerctl
    plex-desktop
    prismlauncher
    python313
    rsyslog
    # rustup in dev shells
    runelite # cuz i love my girlfriends
    samba
    screen
    service-wrapper
    signal-desktop
    slack
    sops
    stow
    syslinux
    tmux
    transmission_4-qt
    udiskie
    udisks2
    unzip
    usbutils
    vim
    vlc
    vscode
    wget
    which
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    xclip
    zip
    zoom-us
    zsh
    #(import "./remctl.nix")
    #  nushell
    #  mlocate defined in service
    #  geticons    # CLI tool for locating icons
    #(import (fetchTarball "channel:nixos-unstable") {}).polymc
    pkgsUnstable.telegram-desktop 
    pkgsUnstable.pangolin-cli
    pkgsUnstable.code-cursor
    pkgsUnstable.noctalia-shell
    # pkgsUnstable.esphome
    pkgsUnstable.opencode

  ];

  system.rebuild.enableNg = true;

  fonts.packages = with pkgs; [
    nerd-fonts.recursive-mono
  ];

  services = {
    gvfs = {
      enable = true;
      # package = pkgs.gnome.gvfs;
    };
    locate = {
      enable = true;
      package = pkgs.mlocate;
      interval = "hourly";
    };
    flatpak.enable = true;
    #gvfs.enable = true;   # this enables network fileshares such as samba to be used with nemo but doesnt seem to work :(
    tailscale.enable = true;
    zerotierone.enable = true;
    power-profiles-daemon.enable = true; #waybar needs this
    upower = {
      enable = true;
      criticalPowerAction = "HybridSleep";
      percentageLow = 14;
      usePercentageForPolicy = true;
    };
    geoclue2.enable = true;
  };
}
