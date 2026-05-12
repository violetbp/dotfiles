
{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
    claude-desktop.url = "github:aaddrick/claude-desktop-debian";

    # dankMaterialShell = {
    #   url = "github:AvengeMedia/DankMaterialShell";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.dgop.follows = "dgop";
    # };
    flake-schemas.url = github:DeterminateSystems/flake-schemas;
    # waybar.url        = "github:Nitepone/Waybar?ref=dev/niri-taskbar";
    catppuccin.url    = "github:catppuccin/nix/release-25.05";
    niri-flake.url    = "github:sodiboo/niri-flake";
    # refind-mod.url    = "github:GrandtheUK/refind-nix";
    # noctalia = {
    #   url = "github:noctalia-dev/noctalia-shell";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    #   inputs.noctalia-qs.follows = "noctalia-qs";
    # };

    # noctalia-qs = {
    #   url = "github:noctalia-dev/noctalia-qs";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };
    humble-manager.url = "github:violetbp/humble-manager";
    humble-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ self, humble-manager, home-manager, claude-desktop, nixpkgs, nix-index-database, catppuccin, niri-flake, ... }: 
  # dankMaterialShell , refind-mod
  {
        

    nixosConfigurations = {
      terra = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          ./hostnameConfig/terra-config.nix   
          ./configuration.nix
          ];
      };
      tassadar = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hostnameConfig/tassadar-config.nix 
                  ./configuration.nix
];
      };
      karax = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          ./hostnameConfig/karax-config.nix  
          ./configuration.nix
          # refind-mod.nixosModules.refind
          catppuccin.nixosModules.catppuccin
          niri-flake.nixosModules.niri
          nix-index-database.nixosModules.nix-index
           { programs.nix-index-database.comma.enable = true; } # comma to install and run
            
          # ({ pkgs, ... }: {
          #   nixpkgs.overlays = [ claude-desktop.overlays.default ];
          #   environment.systemPackages = [ pkgs.claude-desktop ];
          # })
          ({ ... }: {
            environment.systemPackages = [ claude-desktop.packages.x86_64-linux.claude-desktop ];
          })
          home-manager.nixosModules.home-manager
          # {
          #   home-manager = {
          #     # extraSpecialArgs = { inherit inputs; };
          #     useGlobalPkgs = true;
          #     useUserPackages = true;
          #     backupFileExtension = "backup";
          #     users.vboysepe = import ./home.nix;
          #   };
          # }
          
          
          ];
        specialArgs = { inherit inputs; };
      
      };
	    blade = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          ./hostnameConfig/blade-config.nix 
          ./configuration.nix
          # refind-mod.nixosModules.refind
          catppuccin.nixosModules.catppuccin
          
          nix-index-database.nixosModules.nix-index
          { programs.nix-index-database.comma.enable = true; } # comma to install and run
          home-manager.nixosModules.home-manager 
        ];
        specialArgs = { inherit inputs; };

      };      
    };
  };
}
