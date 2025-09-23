{config, pkgs, inputs, ... }:
{
  imports = [ 
    #./plasma.nix
    #./i3.nix
    ./hypr.nix
  ];

  # services.xserver = {
  #   enable = true;
  
  # };
programs.sway.enable = true;
  # hardware = {
  #     opengl.enable = true;
  #     nvidia.modesetting.enable = true;
  # };

  # # hyprland
  # programs.hyprland = {
  #     enable = true;
  #     xwayland.enable = true;
  #     nvidiaPatches = true;
  # };
    


# environment.systemPackages = with pkgs; [
#     # inputs.hyprwm-contrib.packages.${system}.grimblast
#     hyprland
#     swaybg
#     swayidle
#     # TODO
#     # inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland
#   ];
#  # programs.hyprland.enable = true;
#   wayland.windowManager.hyprland = {
#     enable = true;
#  #   package = inputs.hyprland.packages.${pkgs.system}.default;
#     # extraConfig =
#     #   (import ./monitors.nix {
#     #     inherit lib;
#     #     inherit (config) monitors;
#     #   }) +
#     #   (import ./config.nix {
#     #     inherit (config) home colorscheme wallpaper;
#     #   });
#   };
} 