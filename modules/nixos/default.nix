{
  lib,
  pkgs,
  system,
  inputs,
  user,
  host,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.default
    inputs.agenix.nixosModules.default
    inputs.stylix.nixosModules.stylix
    ../../hosts/${host}/configuration.nix
    ./languages
    ./normal-users.nix
    ./wg-vpn
    ./torrent-clients
    ./media.nix
    ./pipewire.nix
    ./pass.nix
    ./dropbox.nix
    ./daw.nix
    ./games.nix
    ./neovim.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = lib.mkDefault system;
  };

  networking.hostName = host;

  nix.settings = {
    substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    ];
  };

  # TODO: remove
  # openldap-2.6.13 build failing due to faulty tests
  nixpkgs.overlays = [
    (final: prev: {
      openldap = prev.openldap.overrideAttrs (old: {
        doCheck = false;
      });
    })
  ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    tree
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = lib.mkDefault "no";
    };
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      inherit user;
    };
    users.${user.name} = import ../../hosts/${host}/home.nix;
  };
}
