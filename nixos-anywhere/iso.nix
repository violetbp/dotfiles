# Customization for a small NixOS installation CD (no desktop).
# Import after installation-cd-minimal.nix — see flake.nix.
{ config, pkgs, ... }:
{
  imports = [ ./network.nix ];
  # services.xserver =  {
  #   enable = true;
  #   displayManager.sddm.enable = true;
  #   desktopManager.plasma5.enable = true;
  # };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vboysepe = {
    isNormalUser = true;
    home = "/home/vboysepe";
    createHome = true;
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "lxd" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDEM5j07kBTjfN6kAShtpux5oxHUtQPQiQyxUNKzV6Ytrj6DlFD/3UXkilagDX2zEPzDOLBp59WTpIMDVp+Jaqf5Iv1WYNXQPN5qNbHutCiDJGwYaCoynUW0dsG419eZgUsKc3tyQucKXRnopzJ0xBJN4k+JU4eHc6dk4Jgfp8fNh7tN5onuTjcHnfeKE9GR/tMWoNxz+wxo9ymBsu/3Jiu/NJGNH9437Kke+w7IaRq8tbxZSsrEm8XgR/QW8iOJog2JOuBN1eqrGtJ6x5xJPZS753akzCVJXFIhiwNbhNOtJKq9Glh6aOFlMF/lKLSUxPwQpmnr9LeEFSdn4JQo9/eYPOvFz0cjjubFXFlhZRu+PErkYBV5Fn+0LCXG+aic99eK6Jvu8k7dKPv7ROCTZdPSS1IOzRalUKoB6ZuAKiYFVafNv6qUjPUnVP5J69Po03nDtzM/E+BwgquW8SJrsmxebYQzn4TzULmKPYOcGwJsrmQKR2jDyK5JnolJUYmAbs= vboysepe@terra"
    ];
  };
  users.users.root.openssh.authorizedKeys.keys = [
    # change this to your ssh key
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDEM5j07kBTjfN6kAShtpux5oxHUtQPQiQyxUNKzV6Ytrj6DlFD/3UXkilagDX2zEPzDOLBp59WTpIMDVp+Jaqf5Iv1WYNXQPN5qNbHutCiDJGwYaCoynUW0dsG419eZgUsKc3tyQucKXRnopzJ0xBJN4k+JU4eHc6dk4Jgfp8fNh7tN5onuTjcHnfeKE9GR/tMWoNxz+wxo9ymBsu/3Jiu/NJGNH9437Kke+w7IaRq8tbxZSsrEm8XgR/QW8iOJog2JOuBN1eqrGtJ6x5xJPZS753akzCVJXFIhiwNbhNOtJKq9Glh6aOFlMF/lKLSUxPwQpmnr9LeEFSdn4JQo9/eYPOvFz0cjjubFXFlhZRu+PErkYBV5Fn+0LCXG+aic99eK6Jvu8k7dKPv7ROCTZdPSS1IOzRalUKoB6ZuAKiYFVafNv6qUjPUnVP5J69Po03nDtzM/E+BwgquW8SJrsmxebYQzn4TzULmKPYOcGwJsrmQKR2jDyK5JnolJUYmAbs= vboysepe@terra"
  ] ;

  services.openssh.enable = true;

  nixpkgs.config.allowUnfree = true;

  system.tools.nixos-install.enable = true;


  networking.networkmanager.enable = true;
  networking.wireless.enable = false;

  networkPresets.wifiNetworks."You know, what." = { psk = "Do not feed the geese bread."; };

  # GUI apps (Kate, GParted, nm-applet, arandr) were dropped from here — they inflate the ISO a lot.
  # Wi‑Fi: use `nmtui` (ships with NetworkManager).
  environment.systemPackages = with pkgs; [
    bashmount
    curl
    efibootmgr
    git
    htop
    nano
    neofetch
    nix-prefetch-scripts
    nixos-install
    nixos-install-tools
    ntfs3g
    syslinux
    tmux
    usbutils
    vim
    wget
    which
  ];
}