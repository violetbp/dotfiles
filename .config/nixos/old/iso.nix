# This module defines a small NixOS installation CD.  It does not
# contain any graphical stuff.
{config, pkgs, ...}:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>

    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];
  services.xserver =  {
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };

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
  nixpkgs.config = {
    allowUnfree = true;
  };

  system.tools.nixos-install.enable = true;

  environment.systemPackages = with pkgs; [
    arandr    # gui diplay manager
    bashmount
    efibootmgr
    git
    gparted
    htop
    kdePackages.kate
    nano
    neofetch
    networkmanagerapplet
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