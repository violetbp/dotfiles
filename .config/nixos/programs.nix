##
## Programs etc, that can be specified easily
##

{ config, pkgs, ... }: {

  nixpkgs.config.allowUnfree = true;

  programs.adb.enable = true;
  
  environment.systemPackages = with pkgs; [
    #(import "/home/vboysepe/.config/nixos/remctl.nix")
    (import (fetchTarball "channel:nixos-unstable") {}).tdesktop #tdesktop need to fetch unstable
    #(import (fetchTarball "channel:nixos-unstable") {}).polymc
    anki
    ansible
    arandr    # gui diplay manager
    autoconf  # make i think?
    automake
    bashmount
    bat
    
    brightnessctl
    discord
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
    htop
    imagemagick
    jdk17_headless
    jq
    kdePackages.kate
    kitty
    krb5
    libreoffice
    lutris
    maim #screenshots
    nano
    ncdu
    nemo
    neofetch
    networkmanagerapplet
    nix-prefetch-scripts
    nixfmt
    nnn
    ntfs3g
    openconnect
    p3x-onenote
    pamixer # volume
    pavucontrol # gui sound manager from pulseaudio
    playerctl
    plex-desktop
    prismlauncher
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
  #  geticons    # CLI tool for locating icons
  #  nushell
  #  mlocate defined in service
  #  zerotierone specified elsewhere

  ];
  fonts.packages = with pkgs; [
    nerd-fonts.recursive-mono
  ];

  programs.steam.enable = true;

  services.zerotierone = {
    enable = true;
  };
    
  services.locate = {
    enable = true;
    package = pkgs.mlocate;
    interval = "hourly";
  };


}
