{ pkgs, lib, inputs, ... }:

{
  #niri shit


  environment = {
    pathsToLink = [ "/libexec" ];
    sessionVariables.NIXOS_OZONE_WL = "1"; # Apply Wayland flags to Electron apps where necessary
  };

  programs = {
    niri.enable = true;
    # waybar.enable = true;
    # waybar.package = "github:Nitepone/Waybar?ref=dev/niri-taskbar";
    dconf.enable = true;
  };

  environment.systemPackages = with pkgs; [
    inputs.waybar.packages.${pkgs.system}.default
    fuzzel
    swaylock
    wayland-utils
    xwayland-satellite
    pkgs.adwaita-icon-theme
    yaru-theme

    swaybg
    #betterlockscreen #prettyier might be nice
  ];

  # this is needed for the application icons to load in. if theres an issue in the future I probably need a local to my user path set up or smth
  systemd.user.services.waybar.serviceConfig = {
    Environment = "\"PATH=$PATH:/run/current-system/sw/bin\"";
  };

  # tty service config
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  services = {
    greetd = {
      enable = true;
      settings.default_session =
        /*
          Return first binary executable name of the given derivation
          Type:
            exe :: Derivation -> String
        */
        let
          exe =
            drv:
            let
              regFiles = lib.mapAttrsToList (f: _: f) (
                lib.filterAttrs (_: t: t == "regular") (builtins.readDir "${drv}/bin")
              );
              mainProg = drv.meta.mainProgram or (lib.head regFiles);
            in
            "${drv}/bin/${mainProg}";

          session = "${pkgs.niri}/bin/niri-session";
          tuigreet = "${exe pkgs.tuigreet}";
        in
        {
          command = "${tuigreet} --time --remember --cmd ${session}";
          user = "greeter";
        };
      # default_session = tuigreet_session;
    };

    # GTK theme config
    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };
  };
}
