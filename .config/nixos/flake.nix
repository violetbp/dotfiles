
{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    }; 
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";   
    };
    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.dgop.follows = "dgop";
    };
    flake-schemas.url = github:DeterminateSystems/flake-schemas;
    waybar.url        = "github:Nitepone/Waybar?ref=dev/niri-taskbar";
    catppuccin.url    = "github:catppuccin/nix/release-25.05";
    niri-flake.url    = "github:sodiboo/niri-flake";
    refind-mod.url    = "github:GrandtheUK/refind-nix";

  };
  outputs = inputs@{ self, home-manager, nixpkgs, nix-index-database, catppuccin, refind-mod, niri-flake, ... }: 
  {
        

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
        modules = [ 
          /etc/nixos/configuration.nix 
          refind-mod.nixosModules.refind
          catppuccin.nixosModules.catppuccin
          niri-flake.nixosModules.niri
          nix-index-database.nixosModules.nix-index
           { programs.nix-index-database.comma.enable = true; } # comma to install and run
          

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.vboysepe = import ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
          
          
          ];
        specialArgs = { inherit inputs; };
      
      };
      
    };
  };
}
