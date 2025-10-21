##
## Programs etc, that can be specified easily
##

{
  config,
  pkgs,
  waybar,
  ...
}:
{

  nixpkgs.config.allowUnfree = true;

  programs = {
    adb.enable = true;
    steam.enable = true;
  };

  catppuccin = {
    enable = true;
    accent = "blue";
    tty.enable = true;
  };

  environment.systemPackages = with pkgs; [
    zsh
    zoom-us
    zip
    xclip
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    which
    wget
    vscode
    vlc
    vim
    usbutils
    unzip
    udisks2
    udiskie
    transmission_3-qt
    tmux
    syslinux
    stow
    slack
    signal-desktop
    service-wrapper
    screen
    samba
    prismlauncher
    plex-desktop
    playerctl
    pavucontrol # gui sound manager from pulseaudio
    pamixer # volume
    p3x-onenote
    openconnect
    obsidian
    ntfs3g
    nnn
    nixfmt
    nix-prefetch-scripts
    networkmanagerapplet
    neofetch
    nemo
    ncdu
    nano
    maim # screenshots
    lutris
    libreoffice
    krb5
    kitty
    kdePackages.kate
    jq
    jdk17_headless
    imagemagick
    htop
    gparted
    google-chrome
    glib
    gjs
    git
    gcc
    firefox
    feh # image viewer
    emacs
    efibootmgr
    discord
    brightnessctl
    bat
    bashmount
    automake
    rsyslog
    autoconf # make i think?
    arandr # gui diplay manager
    ansible
    anki
    #(import "/home/vboysepe/.config/nixos/remctl.nix")
    # whitesur-cursors
    #  nushell
    #  mlocate defined in service
    #  geticons    # CLI tool for locating icons
    #(import (fetchTarball "channel:nixos-unstable") {}).polymc
    (import (fetchTarball "channel:nixos-unstable") { }).tdesktop # tdesktop need to fetch unstable
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.recursive-mono
  ];

  services = {
    locate = {
      enable = true;
      package = pkgs.mlocate;
      interval = "hourly";
    };
    flatpak.enable = true;
    #gvfs.enable = true;   # this enables network fileshares such as samba to be used with nemo but doesnt seem to work :(
    tailscale.enable = true;
    zerotierone.enable = true;
  };
}
