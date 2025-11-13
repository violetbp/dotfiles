##
## Programs etc, that can be specified easily
##

{
  config,
  pkgs,
  inputs,
  ...
}:
{

  nixpkgs.config.allowUnfree = true;

  programs = {
    adb.enable = true;
    steam.enable = true;
    steam.package = pkgs.steam.override {
      extraArgs = "-system-composer";
    };
  };

  catppuccin = {
    enable = true;
    accent = "blue";
    tty.enable = true;
  };

  environment.systemPackages = with pkgs; [
    anki
    ansible
    arandr # gui diplay manager
    autoconf # make i think?
    automake
    bashmount
    bat
    brightnessctl
    cliphist
    discord
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
    ghostty
    htop
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
    nautilus
    ncdu
    nemo-with-extensions
    nemo-preview
    neofetch
    neovim
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
    rsyslog
    runelite # cuz i love my girlfriends
    samba
    screen
    service-wrapper
    signal-desktop
    slack
    stow
    syslinux
    tmux
    transmission_3-qt
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
    #(import "/home/vboysepe/.config/nixos/remctl.nix")
    #  nushell
    #  mlocate defined in service
    #  geticons    # CLI tool for locating icons
    #(import (fetchTarball "channel:nixos-unstable") {}).polymc
    (import (fetchTarball "channel:nixos-unstable") { }).telegram-desktop # tdesktop need to fetch unstable
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
