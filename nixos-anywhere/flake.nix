{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
  inputs.sops-nix.url = "github:Mic92/sops-nix";
  inputs.sops-nix.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    {
      nixpkgs,
      disko,
      nixos-facter-modules,
      sops-nix,
      ...
    }:
    let
      lib = nixpkgs.lib;

      bootstrapModules = [
        disko.nixosModules.disko
        sops-nix.nixosModules.sops
        ./initialconfiguration.nix
        ./hardware-configuration.nix
      ];

      # Auto-generate a nixosConfiguration for each hostnameconfig/<hostname>.nix.
      # deploy.sh creates these files; nixos-anywhere then uses .#<hostname> as the target.
      hostnameFiles = lib.filterAttrs
        (n: t: t == "regular" && lib.hasSuffix ".nix" n)
        (builtins.readDir ./hostnameconfig);

      hostnameConfigs = lib.mapAttrs'
        (filename: _:
          let hostname = lib.removeSuffix ".nix" filename;
          in lib.nameValuePair hostname (nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = bootstrapModules ++ [ (./hostnameconfig + "/${filename}") ];
          }))
        hostnameFiles;
    in
    {
      nixosConfigurations = hostnameConfigs // {

        iso = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            # Omit channel.nix — it embeds a full nixpkgs tree (~hundreds of MB). Use flakes or nix-channel after boot if needed.
            # sops-nix.nixosModules.sops
            ./iso.nix
          ];
        };

        # Legacy fallback — no hostname set.
        # nixos-anywhere --flake .#generic --generate-hardware-config nixos-generate-config ./hardware-configuration.nix root@<ip>
        generic = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = bootstrapModules;
        };

        # nixos-anywhere --flake .#recovery --generate-hardware-config nixos-generate-config ./hardware-configuration-recovery.nix root@<ip>
        recovery = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
          #  disko.nixosModules.disko
            ./configurationrecover.nix
            ./hardware-configuration.nix
          ];
        };

        # not gonna try this yet
        # Slightly experimental: Like generic, but with nixos-facter (https://github.com/numtide/nixos-facter)
        # nixos-anywhere --flake .#generic-nixos-facter --generate-hardware-config nixos-facter facter.json <hostname>
        generic-nixos-facter = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            disko.nixosModules.disko
            /home/vboysepe/.config/nixos/configuration.nix
            nixos-facter-modules.nixosModules.facter
            {
              config.facter.reportPath =
                if builtins.pathExists ./facter.json then
                  ./facter.json
                else
                  throw "Have you forgotten to run nixos-anywhere with `--generate-hardware-config nixos-facter ./facter.json`?";
            }
          ];
        };
      };
    };
}
