{ pkgs, ... }:

{
#xmonad shit

	environment.pathsToLink = [ "/libexec" ];
	services.xserver = {
		enable = true;
		desktopManager = {
      xterm.enable = false;
    };
		windowManager.xmonad = {
			enable = true;
			enableContribAndExtras = true;
			extraPackages = haskellPackages: [
			haskellPackages.dbus
			haskellPackages.List
			haskellPackages.monad-logger
			haskellPackages.xmonad
			];
		};
		# displayManager = {
      	# 	defaultSession = "none+xmonad";
    	# };
    };
}
