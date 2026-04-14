{
  description = "Modular NixOS flake with flake-parts, Disko, and DankMaterialShell";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

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

  outputs = inputs@{ flake-parts, nixpkgs, disko, dms, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      perSystem = { pkgs, ... }: {
        formatter = pkgs.nixfmt-rfc-style;
      };

      flake =
        let
          lib = nixpkgs.lib;

          mkHost = name: cfg:
            lib.nixosSystem {
              inherit (cfg) system;
              specialArgs = {
                inherit inputs;
                hostName = name;
              };
              modules = [
                disko.nixosModules.disko
                dms.nixosModules.dank-material-shell
                cfg.module
                cfg.disko
              ];
            };

          hosts = {
            vmware = {
              system = "x86_64-linux";
              module = ./hosts/vmware/configuration.nix;
              disko = ./hosts/vmware/disko.nix;
            };
          };
        in {
          nixosConfigurations = lib.mapAttrs mkHost hosts;
        };
    };
}
