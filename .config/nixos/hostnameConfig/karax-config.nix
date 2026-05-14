{config, pkgs, ... }:
{
  imports = [

  ];

  networking.hostName = "karax";
  boot.kernelParams = [ "resume_offset=4294656" ];
  boot.resumeDevice = "/dev/mapper/nixos--vg-root";
  swapDevices = [{ device = "/var/swapfile"; size = 24 * 1024; }];

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
  system.stateVersion = "21.11";


}
