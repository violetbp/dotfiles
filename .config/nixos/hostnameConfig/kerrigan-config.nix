{ ... }:
{
  imports = [
    ../configuration.nix
    ../buildServer.nix
    # ../hardwareConfig/kerrigan-hw.nix  # TODO: generate with nixos-generate-config
  ];

  networking.hostName = "kerrigan";

  system.stateVersion = "25.11";
}
