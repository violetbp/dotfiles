{ pkgs, ... }:

{

  imports = [ 
    ./i3.nix
  ];

 ### T495 specific stuff

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/nvme0n1p2";
      preLVM = true;
    };
  };
  networking.hostName = "terra"; # Define your hostname.


  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 10"; }
      { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 10"; }
    ];
  };

  networking.interfaces.enp3s0f0.useDHCP = true;
  networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.wlp1s0.useDHCP = true;

#  virtualisation.virtualbox.host.enable = true;
#  users.extraGroups.vboxusers.members = [ "vboysepe" ];
#  virtualisation.virtualbox.host.enableExtensionPack = true;

  #amd gpu shit idk
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
  ];
  hardware.opengl.driSupport = true;
}
