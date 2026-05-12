{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.networking.networkmanager;

  wifiCfg = config.networkPresets.wifiNetworks;

  getFileName = stringAsChars (x: if x == " " then "-" else x);

  createWifi = ssid: opt: {
    name = ''
      NetworkManager/system-connections/${getFileName ssid}.nmconnection
    '';
    value = {
      mode = "0400";
      source = pkgs.writeText "${ssid}.nmconnection" ''
        [connection]
        id=${ssid}
        type=wifi

        [wifi]
        ssid=${ssid}

        [wifi-security]
        ${optionalString (opt.psk != null) ''
        key-mgmt=wpa-psk
        psk=${opt.psk}''}
      '';
    };
  };

  keyFiles = mapAttrs' createWifi wifiCfg;
in {
  options.networkPresets.wifiNetworks = mkOption {
    description = "Wi‑Fi networks to predefine as NetworkManager connection files (does not enable legacy networking.wireless).";
    type = types.attrsOf (
      types.submodule {
        options.psk = mkOption {
          type = types.nullOr types.str;
          default = null;
        };
      }
    );
    default = {};
  };

  config = mkIf cfg.enable {
    environment.etc = keyFiles;

    systemd.services.NetworkManager-predefined-connections = {
      restartTriggers = mapAttrsToList (name: value: value.source) keyFiles;
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.coreutils}/bin/true";
        ExecReload = "${pkgs.networkmanager}/bin/nmcli connection reload";
      };
      reloadIfChanged = true;
      wantedBy = [ "multi-user.target" ];
    };
  };
}
