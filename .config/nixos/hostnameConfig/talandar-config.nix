{ ... }:
{
  imports = [
    ../hardwareConfig/talandar-hw.nix
    ./talandar-disk.nix
  ];

  networking.hostName = "talandar";
  system.stateVersion = "25.11";
}
