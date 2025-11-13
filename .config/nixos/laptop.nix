##
## Some stuff is only on laptops!
##

{
  config,
  pkgs,
  ...
}:
{


  programs = {
    
  };

  environment.systemPackages = with pkgs; [
    #upower-notify
    batsignal
  ];


  services = {
    
  };
}
