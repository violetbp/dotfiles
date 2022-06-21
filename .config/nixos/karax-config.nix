{config, pkgs, ... }:
{
  imports = [ 
    #./plasma.nix
    ./i3.nix
  ];

  networking.hostName = "karax";
  programs.light.enable = true;

  hardware.sensor.iio.enable = true;

  
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/nvme0n1p5";
      preLVM = true;
    };
  };

  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;


  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "vboysepe" ];
  virtualisation.virtualbox.host.enableExtensionPack = true;
  
  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 10"; }
      { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 10"; }
    ];
  };
}
