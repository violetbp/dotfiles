{ config, pkgs, ... }:

{  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    (import "/home/vboysepe/.config/nixos/remctl.nix")
    (import (fetchTarball "channel:nixos-unstable") {}).tdesktop
    (import (fetchTarball "channel:nixos-unstable") {}).polymc
    #tdesktop need to fetch unstable
    anki
    ansible
    autoconf
    automake
    arandr    # gui diplay manager
    bashmount
    cinnamon.nemo
    discord
    efibootmgr
    emacs
    firefox
    gcc
    glib
    git
    
    google-chrome
    gjs
    gparted
    htop
    jdk17_headless
    kate
    kitty
    krb5
    lutris
    libreoffice
    maim #screenshots
    nano
    neofetch
    networkmanagerapplet
    nix-prefetch-scripts
    ntfs3g
    openconnect
    ncdu
    nnn
    p3x-onenote
    pavucontrol # gui sound manager from pulseaudio
    plex-media-player
    samba
    screen
    slack
    signal-desktop
    stow  
    syslinux
    tmux
    udiskie
    udisks2
    usbutils
    unzip
    vim
    vscode
    wget
    which
    xclip
    zerotierone
    zoom-us
    zip
  ];
}
