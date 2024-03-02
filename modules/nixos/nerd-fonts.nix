{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.nerdFonts;
in
{
  options.nerdFonts = {
    enable = mkEnableOption "nerd fonts";

    fonts = mkOption {
      type = with types; listOf str;
      default = [ "Hack" ];
    };
  };

  config = mkIf cfg.enable {
    fonts.packages = with pkgs; [
      (nerdfonts.override { inherit (cfg) fonts; })
    ];
  };
}
