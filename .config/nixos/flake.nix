
{
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  inputs.home-manager.url = github:nix-community/home-manager;
  
  outputs = { self, nixpkgs, ... }@attrs: {
    nixosConfigurations = {
      terra = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ /etc/nixos/configuration.nix ];
      };
      tassadar = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ /etc/nixos/configuration.nix ];
      };
      karax = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ /etc/nixos/configuration.nix ];
      };
      
    };
  };
}
