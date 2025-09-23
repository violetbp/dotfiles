{ pkgs, ... }:

{
#niri shit

  environment.pathsToLink = [ "/libexec" ];
  programs.niri.enable = true;
  programs.waybar.enable = true;

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
      #  rofi
      #  dmenu
      #  i3status
      #  i3lock
      #  i3blocks
     ];
   };
  };
}
