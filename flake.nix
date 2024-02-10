{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mmuldo-neovim = {
      url = "github:mmuldo/neovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-generators, ... }@inputs:
    let
      mkSystem = host:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs system user host;
          };
          modules = [
            self.nixosModules.default
            self.nixosModules.hardware
            ./hosts/${host}/configuration.nix
          ];
        };

      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      user = {
        name = "matt";
        email = "matt.muldowney@gmail.com";
        fullName = "Matt Muldowney";
        ssh.authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAFqoz4bLdcGPcHunnhqT1mc2VaCZnbAluJtd6Vyp2MK matt.muldowney@gmail.com"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID6jKTS+9HYMQH6yrsasc2RahHHjd3mwe6KCNz8xWTtB matt.muldowney@gmail.com"
        ];
      };
    in
    {
      nixosConfigurations = {
        home-server = mkSystem "home-server";
        linode-vpn = mkSystem "linode-vpn";
      };

      packages.${system} = {
        linode-vpn = nixos-generators.nixosGenerate {
          inherit system;
          format = "linode";
          modules = [
            ./hosts/linode-vpn/configuration.nix
          ];
        };
      };

      nixosModules.default = ./modules/nixos;
      nixosModules.hardware = ./modules/hardware;
      homeManagerModules.default = ./modules/home;
    };
}
