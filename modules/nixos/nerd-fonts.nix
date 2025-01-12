{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.nerdFonts;
in
{
  options.nerdFonts = {
    enable = mkEnableOption "nerd fonts";
  };

  config = mkIf cfg.enable {
    fonts.packages = with pkgs.nerd-fonts; [
      hack
    ];
  };
}
