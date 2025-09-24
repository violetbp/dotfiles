{ pkgs, lib, ... }:

{
#niri shit

  environment ={
    pathsToLink = [ "/libexec" ];
    sessionVariables.NIXOS_OZONE_WL = "1"; # Apply Wayland flags to Electron apps where necessary
  };

  programs = {
    niri.enable = true;
    waybar.enable = true;
    dconf.enable = true;
  };

  services.xserver = {
    enable = true;
    # desktopManager = {
    #   xterm.enable = false;
    # };
 #   displayManager = {
 #     defaultSession = "none+i3";
 #   };
 
   windowManager.i3 = {
    enable = true;
      extraPackages = with pkgs; [
        fuzzel
        swaylock
        wayland-utils
        xwayland-satellite
        swaybg
        #betterlockscreen #prettyier might be nice
      ];
    };
  };

  # Init session with niri
  greetd = {
    enable = true;
    settings = rec {
      tuigreet_session =
        let
          session = "${pkgs.niri-unstable}/bin/niri-session";
          tuigreet = "${lib.exe pkgs.tuigreet}";
        in
        {
          command = "${tuigreet} --time --remember --cmd ${session}";
          user = "greeter";
        };
      default_session = tuigreet_session;
    };
  };
  # GTK theme config
  services.dbus = {
    enable = true;
    packages = [ pkgs.dconf ];
  };


}
