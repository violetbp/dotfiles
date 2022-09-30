# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ 
    ./programs.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  systemd.targets.network-online.wantedBy = pkgs.lib.mkForce []; # Normally ["multi-user.target"]
  systemd.services.NetworkManager-wait-online.wantedBy = pkgs.lib.mkForce []; # Normally ["network-online.target"]

  environment.pathsToLink = [ "/libexec" ];

  hardware.sensor.iio.enable = true;

  # hibernation?
  # boot.kernelParams = [  "resume=/dev/mapper/nixos--vg-root"];# "resume_offset=450560" ];
  # this is unnessicary i have lvm swap?? swapDevices = [ { device = "/var/swapfile"; size = 16384; } ];
  boot.resumeDevice = "/dev/mapper/nixos--vg-root";


  #  xdg.portal.enable = true;
  #  services.flatpak.enable = true;
  environment.shellAliases = {
    ffxiv = "lutris lutris:rungameid/1";
    bloons = "lutris lutris:rungameid/2";
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  # this enables network fileshares such as samba to be used with nemo but doesnt seem to work :(
  services.gvfs.enable = true;

  services.openafsClient.enable = true;
  services.openafsClient.cellName = "cs.cmu.edu";

  virtualisation.docker.enable = true;
  
  # google cast firewall rules
  networking.firewall.allowedUDPPortRanges = [ { from = 32768; to = 60999; } ];

  # services.zerotierone = {
  #   enable = true;
  #   package = with pkgs; zerotierone.overrideAttrs (old: {
  #     cargoDeps = rustPlatform.importCargoLock {
  #       lockFile = fetchurl {
  #         url = "https://raw.githubusercontent.com/zerotier/ZeroTierOne/${old.version}/zeroidc/Cargo.lock";
  #         sha256 = "sha256-pn7t7udZ8A72WC9svaIrmqXMBiU2meFIXv/GRDPYloc=";
  #       };
  #       outputHashes = {
  #         "jwt-0.16.0" = "sha256-P5aJnNlcLe9sBtXZzfqHdRvxNfm6DPBcfcKOVeLZxcM=";
  #       };
  #     };
  #   });
  # };




  # systemd.services.zerotier = {
  #   description = "Start up zerotier";
  #   serviceConfig = {
  #     Type = "forking";
  #     ExecStart = ''${pkgs.screen}/bin/screen -dmS zerotier ${pkgs.zerotierone}/bin/zerotier-one'';         
  #     ExecStop = ''${pkgs.screen}/bin/screen -S zerotier -X quit'';
  #   };
  #   wantedBy = [ "multi-user.target" ]; 
  #   after = [ "network-online.target" ]; # starts after login
  # };

  #services.xserver.xlock.enable=true;  

  fonts.fonts = with pkgs; [
    # Serif fonts
    #roboto ttf_bitstream_vera
    #liberation_ttf dejavu_fonts

    # Mono fonts
    #(nerdfonts.override { fonts = [ 
    #  "FantasqueSansMono" 
    #]; })

    # Emoji
    noto-fonts-emoji
    #openmoji-color
  ];

  fonts.fontconfig = {
    defaultFonts = {
      #emoji = [ "Noto Emoji" ];
      #emoji = [ "OpenMoji Color" ];
    };
  };

  ###### Boot ######
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;
  

  ###### Networking ######
  networking.networkmanager.enable = true; # enables wireless support via networkmanager (nmcli and nmtui)
  networking.search = [ "alias.cs.cmu.edu" "cs.cmu.edu" "ri.cmu.edu cmu.edu" ];
  networking.extraHosts =
  ''
    10.147.19.164 nova
    10.241.172.176 artemis
    10.241.172.176 plex
  '';
  systemd.services.NetworkManager-wait-online.enable = false;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  services.openssh = {
    #enable = true;
    enable = false;
    permitRootLogin = "no"; 
  };


  # Set your time zone.
  time.timeZone = "America/New_York";
  #time.timeZone = "US/Pacific";


  # Container/VM
  virtualisation.lxd.enable = false;
  
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
    createHome = true;
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "lxd" ]; # Enable ‘sudo’ for the user.
  };

  hardware.opengl.enable = true;
}

