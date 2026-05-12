{
  modulesPath,
  lib,
  pkgs,
  config,
  ...
} @ args:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ./network.nix
  ];

   nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  ###### Boot ######
  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    grub.useOSProber = true;
    efi.canTouchEfiVariables = true;
  };
  
  ###### Secrets ######
  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.age.keyFile = "/var/lib/sops-nix/age-key.txt";
  sops.secrets.wifi-psk = {};

  # Write the Wi-Fi connection file with the decrypted PSK via sops template.
  # This is safer than networkPresets.wifiNetworks (which bakes the PSK into the Nix store).
  sops.templates."wifi.nmconnection" = {
    path = "/etc/NetworkManager/system-connections/wifi.nmconnection";
    mode = "0400";
    owner = "root";
    content = ''
      [connection]
      id=wifi
      type=wifi

      [wifi]
      ssid=You know, what.

      [wifi-security]
      key-mgmt=wpa-psk
      psk=${config.sops.placeholder.wifi-psk}

      [ipv4]
      method=auto

      [ipv6]
      method=auto
    '';
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
    };
  };
  networking.networkmanager.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  ###### User ######
  users.users.vboysepe = {
    isNormalUser = true;
    home = "/home/vboysepe";
    # shell = pkgs.zsh;
    createHome = true;
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "disk"
      "networkmanager"
      "lxd"
      "mlocate"
      "adbusers"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDEM5j07kBTjfN6kAShtpux5oxHUtQPQiQyxUNKzV6Ytrj6DlFD/3UXkilagDX2zEPzDOLBp59WTpIMDVp+Jaqf5Iv1WYNXQPN5qNbHutCiDJGwYaCoynUW0dsG419eZgUsKc3tyQucKXRnopzJ0xBJN4k+JU4eHc6dk4Jgfp8fNh7tN5onuTjcHnfeKE9GR/tMWoNxz+wxo9ymBsu/3Jiu/NJGNH9437Kke+w7IaRq8tbxZSsrEm8XgR/QW8iOJog2JOuBN1eqrGtJ6x5xJPZS753akzCVJXFIhiwNbhNOtJKq9Glh6aOFlMF/lKLSUxPwQpmnr9LeEFSdn4JQo9/eYPOvFz0cjjubFXFlhZRu+PErkYBV5Fn+0LCXG+aic99eK6Jvu8k7dKPv7ROCTZdPSS1IOzRalUKoB6ZuAKiYFVafNv6qUjPUnVP5J69Po03nDtzM/E+BwgquW8SJrsmxebYQzn4TzULmKPYOcGwJsrmQKR2jDyK5JnolJUYmAbs= vboysepe@terra"
    ];
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDEM5j07kBTjfN6kAShtpux5oxHUtQPQiQyxUNKzV6Ytrj6DlFD/3UXkilagDX2zEPzDOLBp59WTpIMDVp+Jaqf5Iv1WYNXQPN5qNbHutCiDJGwYaCoynUW0dsG419eZgUsKc3tyQucKXRnopzJ0xBJN4k+JU4eHc6dk4Jgfp8fNh7tN5onuTjcHnfeKE9GR/tMWoNxz+wxo9ymBsu/3Jiu/NJGNH9437Kke+w7IaRq8tbxZSsrEm8XgR/QW8iOJog2JOuBN1eqrGtJ6x5xJPZS753akzCVJXFIhiwNbhNOtJKq9Glh6aOFlMF/lKLSUxPwQpmnr9LeEFSdn4JQo9/eYPOvFz0cjjubFXFlhZRu+PErkYBV5Fn+0LCXG+aic99eK6Jvu8k7dKPv7ROCTZdPSS1IOzRalUKoB6ZuAKiYFVafNv6qUjPUnVP5J69Po03nDtzM/E+BwgquW8SJrsmxebYQzn4TzULmKPYOcGwJsrmQKR2jDyK5JnolJUYmAbs= vboysepe@terra"
  ];

  system.stateVersion = "25.11";
}
