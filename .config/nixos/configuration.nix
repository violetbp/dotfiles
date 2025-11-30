# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  lib,
  pkgs,
  inputs,
  # refind,
  ...
}:

{
  imports = [
    ./programs.nix
    ./starship.nix
    ./laptop.nix
    ./misc.nix
    ./printers.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # hibernation stuff
  boot.kernelParams = [
    # "resume=/dev/mapper/nixos--vg-root"
    "resume_offset=24887296"
  ];
  swapDevices = [
    {
      device = "/var/swapfile";
      size = 16 * 1024; # 16GB in MB
    }
  ];
  boot.resumeDevice = "/dev/mapper/nixos--vg-root";

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };

  home-manager = { 
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.vboysepe = import ./home.nix;
  };
  #  xdg.portal.enable = true;

  # services.openafsClient.enable = true;
  # services.openafsClient.cellName = "cs.cmu.edu";

  # # Container/VM
  # virtualisation.lxd.enable = false;
  # virtualisation.docker.enable = true;

  ###### Boot ######
  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    grub.useOSProber = true;
    efi.canTouchEfiVariables = true;
  };

  ###### Networking ######
  networking = {
    networkmanager.enable = true; # enables wireless support via networkmanager (nmcli and nmtui)
    # search = [ "alias.cs.cmu.edu" "cs.cmu.edu" "ri.cmu.edu cmu.edu" ];

    firewall.allowedUDPPortRanges = [
      {
        from = 32768;
        to = 60999;
      }
    ]; # google cast firewall rules

    firewall.enable = true;
    nftables.enable = true;
    # systemd.services.NetworkManager = {
    #   wantedBy = lib.mkForce [ "multi-user.target" ];
    # };

    extraHosts = ''
      #10.147.19.1    orlana
      #10.147.19.164  nova
      #10.241.172.176 artemis
      10.0.0.125      artemis
      10.241.172.176  plex
      10.0.0.3 orlanahome
      10.0.0.7 haos
    '';

  };
  environment.sessionVariables.DEFAULT_BROWSER = "/var/lib/flatpak/exports/bin/app.zen_browser.zen";

#  boot.loader.refind = {
#            enable = true;
#            maxGenerations = 10;
 #       };


  # xdg.mime.defaultApplications = {
  #   "text/html"                 = "app.zen_browser.zen";
  #   "x-scheme-handler/http"     = "app.zen_browser.zen";
  #   "x-scheme-handler/https"    = "app.zen_browser.zen";
  #   "x-scheme-handler/about"    = "app.zen_browser.zen";
  #   "x-scheme-handler/unknown"  = "app.zen_browser.zen";
  #   "application/x-extension-htm"   = "app.zen_browser.zen";
  #   "application/x-extension-html"  = "app.zen_browser.zen";
  #   "application/x-extension-shtml" = "app.zen_browser.zen";
  #   "application/xhtml+xml"         = "app.zen_browser.zen";
  #   "application/x-extension-xhtml" = "app.zen_browser.zen";
  #   "application/x-extension-xht"   = "app.zen_browser.zen";
  #   "x-scheme-handler/webcal"       = "app.zen_browser.zen";
  #   "x-scheme-handler/mailto"       = "app.zen_browser.zen";

  # };

  services.openssh = {
    #enable = true;
    enable = true;
    settings = {
      PermitRootLogin = "no";
    };
  };

  # Set time zone.
  # time.timeZone = "America/New_York";
  time.timeZone = "US/Pacific";


  ###### Sound ######
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraConfig = {
      pipewire."99-silent-bell.conf" = {
        "context.properties" = {
          "module.x11.bell" = false;
        };
      };
    };
  };
  
  ###### BT ######
  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  services.libinput.touchpad.naturalScrolling = true;

  ###### User ######
  users.users.vboysepe = {
    isNormalUser = true;
    home = "/home/vboysepe";
    shell = pkgs.zsh;
    createHome = true;
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "disk"
      "networkmanager"
      "lxd"
      "mlocate"
      "adbusers"
    ]; # Enable ‘sudo’ for the user.
  };
  security.sudo.extraRules = [
    {
      groups = [ "wheel" ];
      commands = [ 
        { command = "${pkgs.nix}/bin/nix-collect-garbage"; options = [ "NOPASSWD" ]; }
        ];
    }
  ];
  hardware.graphics.enable = true;
}
