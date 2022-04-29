{ config, pkgs, ... }:

{  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  
    (import (fetchTarball "channel:nixos-unstable") {}).tdesktop
    #tdesktop need to fetch unstable
    anki
    ansible
    arandr    # gui diplay manager
    bashmount
    cinnamon.nemo
    discord
    efibootmgr
    emacs
    firefox
    gcc
    git
    google-chrome
    gparted
    htop
    jdk17_headless
    kate
    kitty
    krb5
    lutris
    libreoffice
    maim #screenshots
    multimc
    nano
    neofetch
    networkmanagerapplet
    nix-prefetch-scripts
    ntfs3g
    openconnect
    nnn
    p3x-onenote
    pavucontrol # gui sound manager from pulseaudio
    plex-media-player
    slack
    stow  
    syslinux
    tmux
    usbutils
    unzip
    vim
    vscode
    wget
    which
    xclip
    zoom-us
    zip
  ];
}