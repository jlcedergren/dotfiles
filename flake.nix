{
  description = "My Nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nix-darwin, ... }:
    let
      mkNixos = host: nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/${host}/configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };
    in
    {
      nixosConfigurations = {
        desktop = mkNixos "desktop";
        nixos-vm = mkNixos "nixos-vm";
      };

      darwinConfigurations."Jills-MacBook-Air" = nix-darwin.lib.darwinSystem {
        modules = [ ./hosts/macbook-air/configuration.nix ];
      };

      homeConfigurations."jillced" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        modules = [
          ./home
          ./home/darwin.nix
        ];
      };
    };
}
