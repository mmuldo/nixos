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
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      user = {
        name = "matt";
        email = "matt.muldowney@gmail.com";
        fullName = "Matt Muldowney";
      };
    in
    {
      nixosConfigurations = {
        home-server = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit system;
            inherit user;
          };
          modules = [ 
            ./hosts/home-server/configuration.nix
          ];
        };
      };
    };
}
