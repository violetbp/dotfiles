{ ... }:
{
  imports = [    
    ../hardwareConfig/kerrigan-hw.nix
    ../hardwareConfig/kerrigan-disk.nix
  ];

  networking.hostName = "kerrigan";

  nix.settings.tarball-ttl = 86400; # cache flake inputs for 24h; prevents nix develop from hitting network on every remote build invocation

  system.stateVersion = "25.11";
}
