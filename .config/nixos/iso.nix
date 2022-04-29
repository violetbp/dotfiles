# This module defines a small NixOS installation CD.  It does not
# contain any graphical stuff.
{config, pkgs, ...}:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>

    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vboysepe = {
    isNormalUser = true;
    home = "/home/vboysepe";
    createHome = true;
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "lxd" ]; # Enable ‘sudo’ for the user.
  };
  nixpkgs.config = {
    allowUnfree = true;
  };
    environment.systemPackages = with pkgs; [
    arandr    # gui diplay manager
    bashmount
    efibootmgr
    git
    gparted
    htop
    kate
    nano
    neofetch
    networkmanagerapplet
    nix-prefetch-scripts
    ntfs3g
    syslinux
    tmux
    usbutils
    vim
    wget
    which
  ];
}