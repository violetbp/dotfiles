{ pkgs, ... }:
{
  nix.settings = {
    max-jobs = "auto";
    cores = 0;
    trusted-users = [ "root" "@wheel" "nix-ssh" ];
  };

  # Tmpfs for build scratch space — tune size to available RAM
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "8G";

  # Lower priority so builds don't starve interactive use
  nix.daemonCPUSchedPolicy = "batch";
  nix.daemonIOSchedClass = "idle";

  # Dedicated user for incoming remote builds via SSH
  users.users.nix-ssh = {
    isSystemUser = true;
    group = "nix-ssh";
    shell = pkgs.nologin;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDEM5j07kBTjfN6kAShtpux5oxHUtQPQiQyxUNKzV6Ytrj6DlFD/3UXkilagDX2zEPzDOLBp59WTpIMDVp+Jaqf5Iv1WYNXQPN5qNbHutCiDJGwYaCoynUW0dsG419eZgUsKc3tyQucKXRnopzJ0xBJN4k+JU4eHc6dk4Jgfp8fNh7tN5onuTjcHnfeKE9GR/tMWoNxz+wxo9ymBsu/3Jiu/NJGNH9437Kke+w7IaRq8tbxZSsrEm8XgR/QW8iOJog2JOuBN1eqrGtJ6x5xJPZS753akzCVJXFIhiwNbhNOtJKq9Glh6aOFlMF/lKLSUxPwQpmnr9LeEFSdn4JQo9/eYPOvFz0cjjubFXFlhZRu+PErkYBV5Fn+0LCXG+aic99eK6Jvu8k7dKPv7ROCTZdPSS1IOzRalUKoB6ZuAKiYFVafNv6qUjPUnVP5J69Po03nDtzM/E+BwgquW8SJrsmxebYQzn4TzULmKPYOcGwJsrmQKR2jDyK5JnolJUYmAbs= vboysepe@terra" # karax ans key
    ];
  };
  users.groups.nix-ssh = {};

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };
}
