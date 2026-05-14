{ ... }:
{
  imports = [
    ../configuration.nix
    ../buildServer2.nix
    ../harmonia.nix
    ../hardwareConfig/kerrigan-hw.nix
    ../hardwareConfig/kerrigan-disk.nix
  ];

  networking.hostName = "kerrigan";

  nix.settings.tarball-ttl = 86400;

  system.stateVersion = "25.11";
}
