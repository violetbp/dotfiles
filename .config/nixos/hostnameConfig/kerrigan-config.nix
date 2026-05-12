{ ... }:
{
  imports = [
    ../configuration.nix
    ../buildServer.nix
    ../hardwareConfig/kerrigan-hw.nix
    ../hardwareConfig/kerrigan-disk.nix
  ];

  networking.hostName = "kerrigan";

  system.stateVersion = "25.11";
}
