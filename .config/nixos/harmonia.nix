{ pkgs, ... }:
{
  services.harmonia = {
    enable = true;
    signKeyPaths = [ "/etc/nix/signing-key.sec" ];
    settings.bind = "[::]:5000";
  };

  # Sign all locally-built paths at the daemon level so that artifacts from
  # remote builds (blade/terra delegating to kerrigan via nix.sshServe) are
  # also signed and servable by harmonia.
  nix.settings.secret-key-files = [ "/etc/nix/signing-key.sec" ];

  networking.firewall.allowedTCPPorts = [ 5000 ];

  # Periodically rebuild kerrigan's system closure to keep the cache warm.
  systemd.services.nix-cache-warmup = {
    description = "Warm Harmonia cache by building system closure";
    after = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "nix-cache-warmup" ''
        ${pkgs.nix}/bin/nix build \
          /home/vboysepe/.config/nixos#nixosConfigurations.kerrigan.config.system.build.toplevel \
          --no-link
      ''}";
      User = "root";
    };
  };

  systemd.timers.nix-cache-warmup = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
      RandomizedDelaySec = "1h";
    };
  };
}
