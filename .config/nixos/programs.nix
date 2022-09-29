##
## Programs etc, that can be specified easily
##

{ config, pkgs, ... }: {
  programs.steam.enable = true;
  environment.systemPackages = with pkgs; [
    (import "/home/vboysepe/.config/nixos/remctl.nix")
    (import (fetchTarball "channel:nixos-unstable") {}).tdesktop #tdesktop need to fetch unstable
    (import (fetchTarball "channel:nixos-unstable") {}).polymc
    anki
    ansible
    arandr    # gui diplay manager
    autoconf  # make i think?
    automake
    bashmount
    cinnamon.nemo
    discord
    efibootmgr
    emacs
    firefox
    gcc
    git
    gjs
    glib
    google-chrome
    gparted
    htop
    jdk17_headless
    kate
    kitty
    krb5
    libreoffice
    lutris
    maim #screenshots
    nano
    ncdu
    neofetch
    networkmanagerapplet
    nix-prefetch-scripts
    nnn
    ntfs3g
    nushell
    openconnect
    p3x-onenote
    pavucontrol # gui sound manager from pulseaudio
    plex-media-player
    samba
    screen
    signal-desktop
    slack
    stow  
    syslinux
    tmux
    udiskie
    udisks2
    unzip
    usbutils
    vim
    vlc
    vscode
    wget
    which
    xclip
    #zerotierone specified elsewhere
    zip
    zoom-us
  ];
}
