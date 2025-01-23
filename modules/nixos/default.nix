{ lib, pkgs, system, inputs, user, host, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.default
    inputs.agenix.nixosModules.default
    inputs.stylix.nixosModules.stylix ../../hosts/${host}/configuration.nix
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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = lib.mkDefault system;
  };

  networking.hostName = host;

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
