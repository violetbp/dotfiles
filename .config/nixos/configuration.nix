# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ 
    ./programs.nix
    ./starship.ds
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  systemd.targets.network-online.wantedBy = pkgs.lib.mkForce []; # Normally ["multi-user.target"]
  systemd.services.NetworkManager-wait-online.wantedBy = pkgs.lib.mkForce []; # Normally ["network-online.target"]

  environment.pathsToLink = [ "/libexec" ];

  hardware.sensor.iio.enable = true;

  # hibernation?
  # boot.kernelParams = [  "resume=/dev/mapper/nixos--vg-root"];# "resume_offset=450560" ];
  # this is unnessicary i have lvm swap?? swapDevices = [ { device = "/var/swapfile"; size = 16384; } ];
  boot.resumeDevice = "/dev/mapper/nixos--vg-swap";


  #  xdg.portal.enable = true;
  #  services.flatpak.enable = true;
  environment.shellAliases = {
    ffxiv = "lutris lutris:rungameid/1";
    bloons = "lutris lutris:rungameid/2";
  };

  # this enables network fileshares such as samba to be used with nemo but doesnt seem to work :(
  services.gvfs.enable = true;

  services.openafsClient.enable = true;
  services.openafsClient.cellName = "cs.cmu.edu";

  # Container/VM
  virtualisation.lxd.enable = false;
  virtualisation.docker.enable = true;
  
  # google cast firewall rules
  networking.firewall.allowedUDPPortRanges = [ { from = 32768; to = 60999; } ];

  #services.xserver.xlock.enable=true;  

 
  ###### Boot ######
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  ###### Networking ######
  networking.networkmanager.enable = true; # enables wireless support via networkmanager (nmcli and nmtui)
  networking.search = [ "alias.cs.cmu.edu" "cs.cmu.edu" "ri.cmu.edu cmu.edu" ];
  systemd.services.NetworkManager-wait-online.enable = false;
  networking.extraHosts =
  ''
    10.147.19.1    orlana
    10.147.19.164  nova
    10.241.172.176 artemis
    10.241.172.176 plex
    192.168.1.245 orlanahome
  '';

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  services.openssh = {
    #enable = true;
    enable = false;
    settings = {
	permitRootLogin = "no"; 
    };
  };

  # Set your time zone.
  time.timeZone = "America/New_York";
  #time.timeZone = "US/Pacific";

  
  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];

  ###### Sound ######
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  ###### BT ######
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad.naturalScrolling = true;

  ###### User ######
  users.users.vboysepe = {
    isNormalUser = true;
    home = "/home/vboysepe";
    #shell = pkgs.nushell;
    createHome = true;
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "lxd" "mlocate" "adbusers" ]; # Enable ‘sudo’ for the user.
  };

  hardware.opengl.enable = true;
}

