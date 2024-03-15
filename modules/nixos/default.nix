{ lib, pkgs, system, inputs, user, host, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.default
    ./editors
    ./normal-users.nix
    ./wg-vpn
    ./media.nix
    ./nerd-fonts.nix
    ./pipewire.nix
    ./pass.nix
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
      PasswordAuthentication = true;
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
