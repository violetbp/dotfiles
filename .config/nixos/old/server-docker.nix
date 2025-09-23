# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  virtualisation.docker.enable = true;
  


  nixpkgs.config = {
    allowUnfree = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-1"; # Define your hostname.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  ###### User ######
  users.users.vboysepe = {
    isNormalUser = true;
    #initialHashedPassword = "";
    home = "/home/vboysepe";
    createHome = true;
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "lxd" ]; 
    openssh.authorizedKeys.keys  = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDO0ZXL9ronTeeLtG401EtWLCK6dC13f7DYzG1dW1EoaWHicxJkaHQF8ODEzR2axRWOIvspGVI2mibVItNO07xHCb+ErJCVim9T78oecbN9SGnCXNYHTWimDVmcBsVWM30SKT3ZgUmSUDrPdoBZev+XiaaASQN9ku8hjYDZ8dfEtriA/LAl3gHgqvW/pCsC3laCtZN5c8RBMXq5i/MnITOEje7eMOlCtglleGmSXrIh0RbKhT1iL9VKBvhgyeBoNKRBBb1w9t7C5faXkXOvxIy/RpHKu4tyqkQtZ4SWXgh2v3e0eVHnMVEpxGkkGh/+W2J7/wmxz+8I19pliYgT9DiJbrhw1KcAVA/YilsLhRSd9YDiySC7x6ZtZu7UaL9L6qeIi4XrhrcBVy277D0QQKDQ3Eg4IMBLV+O6QwHBVn6QKrqlrw+CXymftl1eZzj2R3Xisr/8LQp8fY/dzMXkDrKG/znIlKtNL7ZCv+iBaexgS+MRxwakYsDBsj0g2nQy2EwZrevHdQwpprHilFbmGpHjfLSqdtOZIFJQgswB+TZJj2zyjIiu7cX+5c5UDteoIrS+ZZ96z9ptw8Ff6ft8gGMIHFilU/zXZyp/nOUuKZBUbqL6q32QHOECOoaF0pllaR9L1U5BXTGHtZhl5LqUGUB2frmABbO2UcaisMYGAYQGFw== vboysepe@vorazun.fac.cs.cmu.edu" ];
  };
  
	# Allow passwordless sudo
  security.sudo = {
    enable = mkDefault true;
    wheelNeedsPassword = mkImageMediaOverride false;
  };

	# auto login! might as well :)
  services.getty.autologinUser = "vboysepe";

  # show ip on tty
  environment.etc."issue.d/ip.issue".text = "\\4{eno1}\n\\4{eno2}\n\\4\n";
  networking.dhcpcd.runHook = "${pkgs.utillinux}/bin/agetty --reload";


  environment.systemPackages = with pkgs; [
    autoconf  # make i think?
    automake
    bashmount
    efibootmgr
    emacs
    firefox
    gcc
    git
    htop
    kitty
    nano
    ncdu
    neofetch
    nix-prefetch-scripts
    nnn
    ntfs3g
    nushell
    samba
    screen
    syslinux
    tmux
    udiskie
    udisks2
    unzip
    wget
    which
    zerotierone
    zip
  ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    permitRootLogin = "no"; 
  };

  system.stateVersion = "22.05"; # Did you read the comment?

}