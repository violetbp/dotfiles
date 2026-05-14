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
  # stdenv.hostPlatform.system = inputs.system;

  # audio stuff
  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
    { domain = "@audio"; item = "nofile"; type = "soft"; value = "99999"; }
    { domain = "@audio"; item = "nofile"; type = "hard"; value = "99999"; }
  ];
  # musnix = {
  #   enable = true;
  # };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # hibernation stuff
  # sudo filefrag -v /var/swapfile | head
  # sudo filefrag -v /var/swapfile | awk 'NR==4{print $4}' | cut -d. -f1     
  boot.kernelParams = [
    # "resume=/dev/mapper/nixos--vg-root"
    "resume_offset=4294656" # TODO fix this and move it to karax-config
    "mitigations=off"
  ];
  swapDevices = [
    {
      device = "/var/swapfile";
      size = 24 * 1024; # 16GB in MB
    }
  ];
  boot.resumeDevice = "/dev/mapper/nixos--vg-root";

  nix = {
    settings.download-buffer-size = 500000000;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
    settings = {
      substituters = [
        "https://cache.nixos.org"
        "https://niri.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  xdg.portal.enable = true;

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

    firewall.allowedTCPPorts = [ 8080 ];
    firewall.enable = true;
    nftables.enable = true;
    # systemd.services.NetworkManager = {
    #   wantedBy = lib.mkForce [ "multi-user.target" ];
    # };

    extraHosts = ''
      # 10.147.19.1   orlana
      # 10.147.19.164 nova
      10.0.0.125      plex
      10.241.172.176  artemis
      10.0.0.3        orlanahome
      10.0.0.7        haos
      10.0.1.177      kerrigan
    '';

  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  users.users.root.openssh.authorizedKeys.keys =  [
    # change this to your ssh key
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDEM5j07kBTjfN6kAShtpux5oxHUtQPQiQyxUNKzV6Ytrj6DlFD/3UXkilagDX2zEPzDOLBp59WTpIMDVp+Jaqf5Iv1WYNXQPN5qNbHutCiDJGwYaCoynUW0dsG419eZgUsKc3tyQucKXRnopzJ0xBJN4k+JU4eHc6dk4Jgfp8fNh7tN5onuTjcHnfeKE9GR/tMWoNxz+wxo9ymBsu/3Jiu/NJGNH9437Kke+w7IaRq8tbxZSsrEm8XgR/QW8iOJog2JOuBN1eqrGtJ6x5xJPZS753akzCVJXFIhiwNbhNOtJKq9Glh6aOFlMF/lKLSUxPwQpmnr9LeEFSdn4JQo9/eYPOvFz0cjjubFXFlhZRu+PErkYBV5Fn+0LCXG+aic99eK6Jvu8k7dKPv7ROCTZdPSS1IOzRalUKoB6ZuAKiYFVafNv6qUjPUnVP5J69Po03nDtzM/E+BwgquW8SJrsmxebYQzn4TzULmKPYOcGwJsrmQKR2jDyK5JnolJUYmAbs= vboysepe@terra"
  ];
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
  programs.ssh.extraConfig = ''
    Host 10.0.*
      StrictHostKeyChecking no
      UserKnownHostsFile /dev/null
  '';

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
    jack.enable = true;
    extraConfig = {
      pipewire."99-silent-bell.conf" = {
        "context.properties" = {
          "module.x11.bell" = false;
        };
      };
    };
  };
  services.pipewire.wireplumber.extraConfig."10-bluez" = {
    "monitor.bluez.properties" = {
      "bluez5.enable-sbc-xq" = true;
      "bluez5.enable-msbc" = true;
      "bluez5.enable-hw-volume" = true;
      "bluez5.roles" = [
        "hsp_hs"
        "hsp_ag"
        "hfp_hf"
        "hfp_ag"
      ];
    };
  };
  ###### BT ######
  services.blueman.enable = true;
  # hardware.bluetooth = {
  #   enable = true;
  #   settings = {
  #     General = {
  #       Enable = "Source,Sink,Media,Socket";
  #     };
  #   };
  # };
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        #mew ControllerMode = "bredr"; # Fix frequent Bluetooth audio dropouts
        Experimental = true;
        #mew FastConnectable = true;
        #mew Enable = "Source,Sink,Media,Socket";

      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  services.gnome.gnome-keyring.enable = true;

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
      "dialout" #next two are for serial stuff
      "uucp"
    ]; 
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
