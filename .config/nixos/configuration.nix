# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ 
    #./plasma.nix
    ./programs.nix
    ./i3.nix
  ];

  environment.pathsToLink = [ "/libexec" ];

    hardware.sensor.iio.enable = true;


  #  xdg.portal.enable = true;
  #  services.flatpak.enable = true;
  environment.shellAliases = {
    ffxiv = "lutris lutris:rungameid/1";
    bloons = "lutris lutris:rungameid/2";
  };

  nixpkgs.config = {
    allowUnfree = true;
  };
  
  services.openafsClient.enable = true;
  services.openafsClient.cellName = "cs.cmu.edu";

  networking.firewall.allowedUDPPortRanges = [ { from = 32768; to = 60999; } ];


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

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  networking.networkmanager.enable = true; # enables wireless support via networkmanager (nmcli and nmtui)
  networking.search = [ "alias.cs.cmu.edu" "cs.cmu.edu" "ri.cmu.edu cmu.edu" ];



  services.openssh = {
    enable = true;
    #enable = false;
    permitRootLogin = "no"; 
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Container/VM
  virtualisation.lxd.enable = true;
  
  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.blueman.enable = true;
  hardware.bluetooth.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad.naturalScrolling = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vboysepe = {
    isNormalUser = true;
    home = "/home/vboysepe";
    createHome = true;
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "lxd" ]; # Enable ‘sudo’ for the user.
  };

  programs.steam.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;


  hardware.opengl.enable = true;


  # This value determines the NixOS release from which the default settings for stateful data, like file locations and database versions on your system were taken. It‘s perfectly fine and recommended to leave this value at the release version of the first install of this system. Before changing this value read the documentation for this option (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

