{ lib, config, inputs, pkgs, ...}:

with lib;
let
  cfg = config.spicetify;
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModule
  ];

  options.spicetify = {
    enable = mkEnableOption "spicetify";

    theme = mkOption {
      type = types.str;
    };

    colorscheme = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "spotify" ];

    programs.spicetify = {
      enable = true;
      theme = spicePkgs.themes.${cfg.theme};
      colorScheme = cfg.colorscheme;
    };
  };
}
