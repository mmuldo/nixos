{ lib, inputs, ... }:
{
  imports = [
    ./user.nix
    ./shells
    ./menus
    ./terminal-emulators
    ./window-managers
    inputs.nix-colors.homeManagerModules.default
    ./spicetify.nix
    ./colorls.nix
    ./bars
    ./cava.nix
    ./zathura.nix
  ];

  colorScheme = lib.mkDefault inputs.nix-colors.colorSchemes.rose-pine;

  home.file.".config/nixpkgs/config.nix".text = "{ allowUnfree = true; }";
}
