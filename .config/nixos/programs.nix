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
    bat
    prismlauncher
    anki
    ansible
    arandr    # gui diplay manager
    autoconf  # make i think?
    automake
    bashmount
    nemo
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
    kdePackages.kate
    kitty
    krb5
    libreoffice
    lutris
    maim #screenshots
    #mlocate defined in service
    nano
    ncdu
    neofetch
    networkmanagerapplet
    nix-prefetch-scripts
    nixfmt
    nnn
    ntfs3g
  #  nushell
    openconnect
    p3x-onenote
    pavucontrol # gui sound manager from pulseaudio
    plex-desktop
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
    xclip
    #zerotierone specified elsewhere
    zip
    zoom-us


    bspwm
    sxhkd
    #picom-ibhagwan-git
    calcurse
    #todotxt
    feh
    jq
    
    betterlockscreen
    brightnessctl
    playerctl
    imagemagick


    #eww-wayland # Bar and Widgets
    pamixer # volume
  #  hyprland    # git # Wayland Compositor/WM
  #  nerd-fonts-mononoki       # Font for bar text and icons
  #  nerd-fonts-jetbrains-mono # Font for bar text and icons
#    dunst       # Notification Daemon
#    trayer      # Systray Utility
#   mpvpaper    # Video Backgrounds
#    macchina    # (Optional) Fetch Script
#    socat       # Socket utility for eww workspace module
    swaybg
  #  geticons    # CLI tool for locating icons
    xwayland-satellite 


  ];
  fonts.packages = with pkgs; [
    
    nerd-fonts.recursive-mono
  ];
  #environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.steam.enable = true;

  services.zerotierone = {
    enable = true;
#    package = with pkgs; zerotierone.overrideAttrs (old: {
#      cargoDeps = rustPlatform.importCargoLock {
#        lockFile = fetchurl {
#          url = "https://raw.githubusercontent.com/zerotier/ZeroTierOne/${old.version}/zeroidc/Cargo.lock";
#          sha256 = "sha256-pn7t7udZ8A72WC9svaIrmqXMBiU2meFIXv/GRDPYloc=";
#        };
#        outputHashes = {
#          "jwt-0.16.0" = "sha256-P5aJnNlcLe9sBtXZzfqHdRvxNfm6DPBcfcKOVeLZxcM=";
#        };
#      };
 #   });
  };
    
  services.locate = {
    enable = true;
    package = pkgs.mlocate;
    interval = "hourly";
  };


}
