{ ... }:
{
  imports = [
    ../configuration.nix
    ../buildServer2.nix
    ../hardwareConfig/kerrigan-hw.nix
    ../hardwareConfig/kerrigan-disk.nix
  ];

  networking.hostName = "kerrigan";

  system.stateVersion = "25.11";
}
