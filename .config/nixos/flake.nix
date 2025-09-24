
{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs;
    home-manager.url = github:nix-community/home-manager;
    flake-schemas.url = github:DeterminateSystems/flake-schemas;
  };
  outputs = { self, nixpkgs, ... }@attrs: {
    
    let
      system = "x86_64-linux";

      overlays = import ./lib/overlays.nix { inherit inputs system; };

      pkgs = import nixpkgs {
        inherit overlays system;
        config.allowUnfree = true;
      };

      neovim = self.homeConfigurations.niri-hdmi.config.programs.neovim-ide.finalPackage;
    in{
      schemas =
        inputs.flake-schemas.schemas //
        import ./lib/schemas.nix { inherit (inputs) flake-schemas;
      };
    };

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
