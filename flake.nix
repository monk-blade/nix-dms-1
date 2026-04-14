{
  description = "NixOS VMware guest with Disko and DankMaterialShell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, disko, dms, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
    in {
      nixosConfigurations.vmware = lib.nixosSystem {
        inherit system;

        specialArgs = { inherit inputs; };

        modules = [
          disko.nixosModules.disko
          dms.nixosModules.dank-material-shell
          ./hosts/vmware/configuration.nix
          ./hosts/vmware/disko.nix
        ];
      };
    };
}
