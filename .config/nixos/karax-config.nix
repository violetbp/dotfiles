{config, pkgs, ... }:
{
  imports = [   
    ./windowManager/niri.nix
  ];

  networking.hostName = "karax";

  #IIO stands for the Industrial I/O subsystem of the Linux Kernel
  #I dont actually think this machine has one anymore ()
  hardware.sensor.iio.enable = true; 
 
  
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/nvme0n1p5";
      preLVM = true;
    };
  };

  # virtualisation.virtualbox.host.enable = false;
  # users.extraGroups.vboxusers.members = [ "vboysepe" ];
  # virtualisation.virtualbox.host.enableExtensionPack = true;
  
  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 10"; }
      { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 10"; }
    ];
  };
}
