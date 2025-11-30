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
    batsignal
  ];


  services = {
    logind = {
      settings.Login = {
        HandleLidSwitch  = "suspend-then-hibernate";
        HandlePowerKey   = "hibernate";
      };
      # extraConfig = ''
      #   LidSwitchIgnoreInhibited=yes
      # '';
      # SleepOperation = "suspend";
      # IdleAction = "suspend";
    };
  };

  
  # services.acpid.enable = true;


  ##### laptop stuff #####
  # services.thermald.enable = true;
  # powerManagement.enable = true;
  # powerManagement.powertop.enable = true;
  # services.auto-cpufreq.enable = true;
  # services.auto-cpufreq.settings = {
  #   battery = {
  #     governor = "performance";#powersave";
  #     turbo = "auto";
  #   };
  #   charger = {
  #     governor = "performance";
  #     turbo = "auto";
  #   };
  # };

}
