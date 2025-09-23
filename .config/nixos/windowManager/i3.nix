{ pkgs, ... }:

{
#i3 shit

  environment.pathsToLink = [ "/libexec" ];
  
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
    };
 #   displayManager = {
 #     defaultSession = "none+i3";
 #   };
 #   windowManager.i3 = {
 #     enable = true;
 #     extraPackages = with pkgs; [
 #       rofi
 #       dmenu
 #       i3status
 #       i3lock
 #       i3blocks
 #     ];
 #   };
  };
}
