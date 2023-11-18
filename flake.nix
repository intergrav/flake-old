{
  description = "Devin's Nix Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: {
    nixosConfigurations = {
      devins-nixos-pc = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/devins-nixos-pc/configuration.nix
        ];
        specialArgs = {
          inherit inputs;
          system = "x86_64-linux";
        };
      };
    };
  };
}
