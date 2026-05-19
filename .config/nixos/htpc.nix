# HTPC helper: Steam Big Picture at niri startup + Firefox kiosk shortcuts for non-Steam games.
# Import only on hosts that load niri-flake (e.g. blade, karax). See flake.nix module list order.
#
# programs.niri.settings is declared by niri-flake's settings module (not the main nixos niri module).

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.niri-flake.lib.internal.settings-module ];

  programs.niri.settings.spawn-at-startup = [
    {
      sh = "sleep 3; exec ${lib.getExe config.programs.steam.package} -bigpicture";
    }
  ];

  environment.systemPackages =
    let
      firefoxExe = lib.getExe pkgs.firefox;
      mkKiosk =
        name: url:
        pkgs.writeShellScriptBin name ''
          export MOZ_ENABLE_WAYLAND=1
          exec ${firefoxExe} --kiosk '${url}' "$@"
        '';
    in
    [
      (mkKiosk "launch-mlb" "https://www.mlb.tv")
      (mkKiosk "launch-f1" "https://f1tv.formula1.com")
      bluetui
      bluez
    ];

  

  
}
