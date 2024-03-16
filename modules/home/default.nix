{ lib, inputs, ... }:
{
  imports = [
    ./user.nix
    ./shells
    ./terminal-emulators
    ./window-managers
    inputs.nix-colors.homeManagerModules.default
    ./spicetify.nix
  ];

  colorScheme = lib.mkDefault inputs.nix-colors.colorSchemes.rose-pine;

  home.file.".config/nixpkgs/config.nix".text = "{ allowUnfree = true; }";
}
