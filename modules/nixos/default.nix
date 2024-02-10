{ pkgs, ... }:
{
  imports = [
    ./editors
    ./normal-users.nix
    ./wg-vpn
    ./media.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    tree
  ];
}
