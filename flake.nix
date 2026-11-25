{
  description = "My Nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nix-darwin, ... }: {

    # Main Mac: nix-darwin for the system, standalone home-manager for the user
    darwinConfigurations."Jills-MacBook-Air" = nix-darwin.lib.darwinSystem {
      modules = [ ./darwin.nix ];
    };

    homeConfigurations."jillced" =
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        modules = [ ./home.nix ];
      };

    # NixOS machines: home-manager is built into the system rebuild
    nixosConfigurations."nixos-vm" = nixpkgs.lib.nixosSystem {
      modules = [
        ./hosts/nixos-vm/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.jillced = import ./home.nix;
        }
      ];
    };
  };
}
