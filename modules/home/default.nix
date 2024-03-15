{ lib, inputs, ... }:
{
  imports = [
    ./user.nix
    ./shells
    ./terminal-emulators
    ./window-managers
    inputs.nix-colors.homeManagerModules.default
  ];

  colorScheme = lib.mkDefault inputs.nix-colors.colorSchemes.rose-pine;
}
