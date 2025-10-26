# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./programs.nix
    ./starship.nix
    ./misc.nix
  ];
  nix.settings = { download-buffer-size = 524288000; # 500 MiB
   }; 

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

  xdg.mime.defaultApplications = {
    "text/html" = "app.zen_browser.zen";
    "x-scheme-handler/http" = "app.zen_browser.zen";
    "x-scheme-handler/https" = "app.zen_browser.zen";
    "x-scheme-handler/about" = "app.zen_browser.zen";
    "x-scheme-handler/unknown" = "app.zen_browser.zen";
  };

  #laptop stuff
  services.thermald.enable = true;
  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };

  services.logind = {
    lidSwitch = "suspend";
    # SleepOperation = "suspend";
    # IdleAction = "suspend";

    powerKey = "suspend";
    # extraConfig = ''
    #   HandlePowerKey=ignore
    #   HandleSuspendKey=ignore
    #   HandleHibernateKey=ignore
    # '';
  };

  services.openssh = {
    #enable = true;
    enable = false;
    settings = {
      permitRootLogin = "no";
    };
  };

  # Set your time zone.
  # time.timeZone = "America/New_York";
  time.timeZone = "US/Pacific";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];

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
        { command = "/run/current-system/sw/bin/nixos-rebuild"; options = [ "NOPASSWD" ]; } 
        { command = "/run/current-system/sw/bin/nix-collect-garbage"; options = [ "NOPASSWD" ]; }
        ];
    }
  ];
  hardware.graphics.enable = true;
}
