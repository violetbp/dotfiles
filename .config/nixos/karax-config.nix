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
  boot.initrd.availableKernelModules = [
    # trimmed irrelevant ones
    "thinkpad_acpi"
  ];
  # virtualisation.virtualbox.host.enable = false;
  # users.extraGroups.vboxusers.members = [ "vboysepe" ];
  # virtualisation.virtualbox.host.enableExtensionPack = true;
  
}
